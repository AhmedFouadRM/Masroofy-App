import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/domain/entities/backup_preview.dart';
import 'package:masroofy/features/settings/domain/usecases/clear_all_data.dart';
import 'package:masroofy/features/settings/domain/usecases/export_backup.dart';
import 'package:masroofy/features/settings/domain/usecases/export_expenses_csv.dart';
import 'package:masroofy/features/settings/domain/usecases/pick_backup.dart';
import 'package:masroofy/features/settings/domain/usecases/restore_backup.dart';
import 'package:masroofy/features/settings/presentation/cubits/data_management_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockExportCsv extends Mock implements ExportExpensesCsv {}

class _MockExportBackup extends Mock implements ExportBackup {}

class _MockPickBackup extends Mock implements PickBackup {}

class _MockRestore extends Mock implements RestoreBackup {}

class _MockClear extends Mock implements ClearAllData {}

String _label({String? seedKey, String? name}) => seedKey ?? name ?? '';

String _walletLabel({String? seedKey, String? name}) => seedKey ?? name ?? '';

void main() {
  setUpAll(() {
    registerFallbackValue(CurrencyUtils.defaultCurrency);
    registerFallbackValue(_label);
    registerFallbackValue(_walletLabel);
  });

  late _MockExportCsv exportCsv;
  late _MockExportBackup exportBackup;
  late _MockPickBackup pickBackup;
  late _MockRestore restore;
  late _MockClear clear;

  final picked = PickedBackup(
    json: '{"backup":true}',
    preview: BackupPreview(exportedAt: DateTime.utc(2026, 10, 9), expenses: 3, categories: 8, budgets: 1, recurring: 0),
  );
  const storage = Failure.storage(message: 'disk');

  setUp(() {
    exportCsv = _MockExportCsv();
    exportBackup = _MockExportBackup();
    pickBackup = _MockPickBackup();
    restore = _MockRestore();
    clear = _MockClear();
  });

  DataManagementCubit build() => DataManagementCubit(exportCsv, exportBackup, pickBackup, restore, clear);

  group('export CSV', () {
    blocTest<DataManagementCubit, DataManagementState>(
      'is busy, then completed',
      setUp: () => when(
        () => exportCsv(
          currency: any(named: 'currency'),
          categoryLabel: any(named: 'categoryLabel'),
          walletLabel: any(named: 'walletLabel'),
        ),
      ).thenAnswer((_) async => const Right(unit)),
      build: build,
      act: (cubit) => cubit.exportCsv(
        currency: CurrencyUtils.defaultCurrency,
        categoryLabel: _label,
        walletLabel: _walletLabel,
      ),
      expect: () => [
        const DataManagementState(busy: DataAction.exportCsv),
        const DataManagementState(completed: DataAction.exportCsv),
      ],
    );

    blocTest<DataManagementCubit, DataManagementState>(
      'reports a failure for the snackbar',
      setUp: () => when(
        () => exportCsv(
          currency: any(named: 'currency'),
          categoryLabel: any(named: 'categoryLabel'),
          walletLabel: any(named: 'walletLabel'),
        ),
      ).thenAnswer((_) async => const Left(Failure.exportFailed(message: 'x'))),
      build: build,
      act: (cubit) => cubit.exportCsv(
        currency: CurrencyUtils.defaultCurrency,
        categoryLabel: _label,
        walletLabel: _walletLabel,
      ),
      expect: () => [
        const DataManagementState(busy: DataAction.exportCsv),
        const DataManagementState(
          failedAction: DataAction.exportCsv,
          failure: Failure.exportFailed(message: 'x'),
        ),
      ],
    );
  });

  blocTest<DataManagementCubit, DataManagementState>(
    'export backup completes',
    setUp: () => when(() => exportBackup()).thenAnswer((_) async => const Right(unit)),
    build: build,
    act: (cubit) => cubit.exportBackup(),
    expect: () => [
      const DataManagementState(busy: DataAction.exportBackup),
      const DataManagementState(completed: DataAction.exportBackup),
    ],
  );

  test('a second action is ignored while one runs', () async {
    when(() => exportBackup()).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      return const Right(unit);
    });
    when(() => clear()).thenAnswer((_) async => const Right(unit));
    final cubit = build();
    addTearDown(cubit.close);

    final first = cubit.exportBackup();
    await cubit.clearAll();
    await first;

    verifyNever(() => clear());
  });

  group('restore', () {
    blocTest<DataManagementCubit, DataManagementState>(
      'a valid file waits for confirmation and replaces nothing yet',
      setUp: () => when(() => pickBackup()).thenAnswer((_) async => Right(picked)),
      build: build,
      act: (cubit) => cubit.pickBackup(),
      expect: () => [
        const DataManagementState(busy: DataAction.restore),
        DataManagementState(pendingRestore: picked),
      ],
      verify: (_) => verifyNever(() => restore(any())),
    );

    blocTest<DataManagementCubit, DataManagementState>(
      'cancelling the picker is silent',
      setUp: () => when(() => pickBackup()).thenAnswer((_) async => const Right(null)),
      build: build,
      act: (cubit) => cubit.pickBackup(),
      expect: () => [
        const DataManagementState(busy: DataAction.restore),
        const DataManagementState(),
      ],
    );

    blocTest<DataManagementCubit, DataManagementState>(
      'an invalid file fails with a validation failure',
      setUp: () => when(() => pickBackup()).thenAnswer(
        (_) async => const Left(Failure.validation(field: 'backup', reason: ValidationReason.invalidFormat)),
      ),
      build: build,
      act: (cubit) => cubit.pickBackup(),
      expect: () => [
        const DataManagementState(busy: DataAction.restore),
        const DataManagementState(
          failedAction: DataAction.restore,
          failure: Failure.validation(field: 'backup', reason: ValidationReason.invalidFormat),
        ),
      ],
    );

    blocTest<DataManagementCubit, DataManagementState>(
      'confirming restores the picked text',
      setUp: () {
        when(() => pickBackup()).thenAnswer((_) async => Right(picked));
        when(() => restore(any())).thenAnswer((_) async => const Right(unit));
      },
      build: build,
      act: (cubit) async {
        await cubit.pickBackup();
        await cubit.confirmRestore();
      },
      skip: 2,
      expect: () => [
        const DataManagementState(busy: DataAction.restore),
        const DataManagementState(completed: DataAction.restore),
      ],
      verify: (_) => verify(() => restore('{"backup":true}')).called(1),
    );

    blocTest<DataManagementCubit, DataManagementState>(
      'cancelling the confirmation drops the file',
      setUp: () => when(() => pickBackup()).thenAnswer((_) async => Right(picked)),
      build: build,
      act: (cubit) async {
        await cubit.pickBackup();
        cubit.cancelRestore();
      },
      skip: 2,
      expect: () => [const DataManagementState()],
    );

    blocTest<DataManagementCubit, DataManagementState>(
      'confirming with nothing picked does nothing',
      build: build,
      act: (cubit) => cubit.confirmRestore(),
      expect: () => <DataManagementState>[],
    );
  });

  group('clear all data', () {
    blocTest<DataManagementCubit, DataManagementState>(
      'completes',
      setUp: () => when(() => clear()).thenAnswer((_) async => const Right(unit)),
      build: build,
      act: (cubit) => cubit.clearAll(),
      expect: () => [
        const DataManagementState(busy: DataAction.clearAll),
        const DataManagementState(completed: DataAction.clearAll),
      ],
    );

    blocTest<DataManagementCubit, DataManagementState>(
      'a failure is reported',
      setUp: () => when(() => clear()).thenAnswer((_) async => const Left(storage)),
      build: build,
      act: (cubit) => cubit.clearAll(),
      expect: () => [
        const DataManagementState(busy: DataAction.clearAll),
        const DataManagementState(failedAction: DataAction.clearAll, failure: storage),
      ],
    );
  });

  test('every completion is a fresh state change, so the screen sees each one', () async {
    when(() => clear()).thenAnswer((_) async => const Right(unit));
    final cubit = build();
    addTearDown(cubit.close);
    final seen = <DataManagementState>[];
    cubit.stream.listen(seen.add);

    await cubit.clearAll();
    await cubit.clearAll();
    await pumpEventQueue();

    expect(seen.where((s) => s.completed != null), hasLength(2));
  });
}
