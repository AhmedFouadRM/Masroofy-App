import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/presentation/cubits/wallet_count_cubit.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_draft.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';
import 'package:masroofy/features/wallets/domain/usecases/delete_wallet.dart';
import 'package:masroofy/features/wallets/domain/usecases/save_wallet.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallet_form_cubit.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallets_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockWallets extends Mock implements IWalletRepository {}

class _MockSave extends Mock implements SaveWallet {}

class _MockDelete extends Mock implements DeleteWallet {}

final _today = LocalDate(2026, 10, 9);
final _epoch = DateTime.utc(2026, 10, 9);

Wallet _wallet(int id, {String? name}) => Wallet(
  id: id,
  seedKey: id == 1 ? 'me' : null,
  name: id == 1 ? null : (name ?? 'Wallet $id'),
  icon: id == 1 ? 'person' : 'child',
  color: 0xFF3B82F6,
  sortOrder: id,
  createdAt: _epoch,
  updatedAt: _epoch,
);

WalletSummary _summary(int id, {String? name, int balance = 0, int rows = 0, int templates = 0}) => WalletSummary(
  wallet: _wallet(id, name: name),
  balance: Money(balance),
  transactionCount: rows,
  transferCount: 0,
  templateCount: templates,
);

void main() {
  late _MockWallets wallets;

  setUpAll(() {
    registerFallbackValue(DateRange(_today, _today));
    registerFallbackValue(const WalletDraft(icon: 'person', color: 0));
  });

  setUp(() {
    wallets = _MockWallets();
    when(() => wallets.watchSummaries(any())).thenAnswer(
      (_) => Stream.value(Right([_summary(1, balance: 450000), _summary(2, name: 'Son', balance: 50000)])),
    );
  });

  group('WalletsCubit', () {
    blocTest<WalletsCubit, WalletsState>(
      'loads every wallet with its balance this month, to date',
      build: () => WalletsCubit(wallets, today: () => _today),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.status, WalletsStatus.loaded);
        expect(cubit.state.wallets.map((w) => (w.wallet.id, w.balance)), [
          (1, const Money(450000)),
          (2, const Money(50000)),
        ]);
        verify(() => wallets.watchSummaries(DateRange(LocalDate(2026, 10, 1), _today))).called(1);
      },
    );

    blocTest<WalletsCubit, WalletsState>(
      'follows the wallets live',
      setUp: () => when(() => wallets.watchSummaries(any())).thenAnswer(
        (_) => Stream.fromIterable([
          Right([_summary(1)]),
          Right([_summary(1), _summary(2, name: 'Son')]),
        ]),
      ),
      build: () => WalletsCubit(wallets, today: () => _today),
      act: (cubit) => cubit.load(),
      verify: (cubit) => expect(cubit.state.wallets, hasLength(2)),
    );

    blocTest<WalletsCubit, WalletsState>(
      'a failed load is reported',
      setUp: () => when(() => wallets.watchSummaries(any())).thenAnswer(
        (_) => Stream.value(const Left(Failure.storage(message: 'disk'))),
      ),
      build: () => WalletsCubit(wallets, today: () => _today),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.status, WalletsStatus.failure);
        expect(cubit.state.loadFailure, const Failure.storage(message: 'disk'));
      },
    );
  });

  group('WalletCountCubit', () {
    blocTest<WalletCountCubit, int?>(
      'is the number of wallets, once known',
      build: () => WalletCountCubit(wallets, today: () => _today),
      act: (cubit) => cubit.load(),
      expect: () => [2],
    );

    blocTest<WalletCountCubit, int?>(
      'follows an added wallet',
      setUp: () => when(() => wallets.watchSummaries(any())).thenAnswer(
        (_) => Stream.fromIterable([
          Right([_summary(1)]),
          Right([_summary(1), _summary(2)]),
        ]),
      ),
      build: () => WalletCountCubit(wallets, today: () => _today),
      act: (cubit) => cubit.load(),
      expect: () => [1, 2],
    );

    test('starts unknown, and stays so when the load fails', () async {
      when(() => wallets.watchSummaries(any())).thenAnswer(
        (_) => Stream.value(const Left(Failure.storage(message: 'disk'))),
      );
      final cubit = WalletCountCubit(wallets, today: () => _today);
      expect(cubit.state, isNull);

      cubit.load();
      await pumpEventQueue();

      expect(cubit.state, isNull);
      await cubit.close();
    });
  });

  group('WalletFormCubit', () {
    late _MockSave save;
    late _MockDelete delete;

    setUp(() {
      save = _MockSave();
      delete = _MockDelete();
      when(() => wallets.getById(1)).thenAnswer((_) async => Right(_wallet(1)));
      when(() => wallets.getById(2)).thenAnswer((_) async => Right(_wallet(2, name: 'Son')));
    });

    WalletFormCubit build({int? id, bool isDefault = false}) =>
        WalletFormCubit(wallets, save, delete, walletId: id, isDefault: isDefault, today: () => _today);

    blocTest<WalletFormCubit, WalletFormState>(
      'a new wallet starts ready, with the first icon and colour, not editing',
      build: build,
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        final s = cubit.state;
        expect((s.status, s.isEditing, s.name, s.icon), (WalletFormStatus.ready, false, '', 'person'));
        expect(s.canSave, isFalse, reason: 'a name is required');
        verifyNever(() => wallets.watchSummaries(any()));
      },
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'saves the typed name, icon and colour',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(5)),
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit
          ..nameChanged(' Wife ')
          ..iconSelected('woman')
          ..colorSelected(0xFF112233);
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.status, WalletFormStatus.saved);
        verify(
          () => save(
            const WalletDraft(name: ' Wife ', icon: 'woman', color: 0xFF112233),
            id: any(named: 'id'),
          ),
        ).called(1);
      },
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'a duplicate name lands on the name field, and typing clears it',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer(
        (_) async => const Left(Failure.validation(field: 'name', reason: ValidationReason.duplicate)),
      ),
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit.nameChanged('Son');
        await cubit.save();
        expect(cubit.state.nameError, ValidationReason.duplicate);
        expect(cubit.state.status, WalletFormStatus.ready);
        cubit.nameChanged('Sons');
      },
      verify: (cubit) => expect(cubit.state.nameError, isNull),
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'another failure is reported without a name error',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer(
        (_) async => const Left(Failure.storage(message: 'disk')),
      ),
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit.nameChanged('Son');
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.failure, const Failure.storage(message: 'disk'));
        expect(cubit.state.nameError, isNull);
      },
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'editing pre-fills the wallet',
      build: () => build(id: 2),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        final s = cubit.state;
        expect(
          (s.status, s.name, s.icon, s.color, s.isEditing),
          (WalletFormStatus.ready, 'Son', 'child', 0xFF3B82F6, true),
        );
        expect(s.keepsSeedName, isFalse);
        expect(s.canSave, isTrue);
      },
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'editing Me keeps its seeded name until a name is typed',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(1)),
      build: () => build(id: 1, isDefault: true),
      act: (cubit) async {
        await cubit.load();
        expect(cubit.state.keepsSeedName, isTrue);
        expect(cubit.state.canSave, isTrue, reason: 'no name is typed, and none is needed');
        cubit.iconSelected('home');
        await cubit.save();
      },
      verify: (cubit) => verify(
        () => save(const WalletDraft(icon: 'home', color: 0xFF3B82F6), id: 1),
      ).called(1),
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'typing a name over Me replaces its seeded name',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(1)),
      build: () => build(id: 1),
      act: (cubit) async {
        await cubit.load();
        cubit.nameChanged('Mine');
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.keepsSeedName, isFalse);
        verify(() => save(const WalletDraft(name: 'Mine', icon: 'person', color: 0xFF3B82F6), id: 1)).called(1);
      },
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'emptying the name of Me stops Save: there is no seeded name left to keep',
      build: () => build(id: 1),
      act: (cubit) async {
        await cubit.load();
        cubit.nameChanged('  ');
      },
      verify: (cubit) => expect(cubit.state.canSave, isFalse),
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'Set as default starts from whether the wallet is the default one',
      build: () => build(id: 2, isDefault: true),
      act: (cubit) async {
        await cubit.load();
        cubit.defaultChanged(value: false);
      },
      verify: (cubit) => expect((cubit.state.wasDefault, cubit.state.makeDefault), (true, false)),
    );

    blocTest<WalletFormCubit, WalletFormState>(
      "knows the other wallets, and that the last one can't be deleted",
      build: () => build(id: 2),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.others.map((w) => w.wallet.id), [1]);
        expect(cubit.state.usage?.wallet.id, 2);
        expect(cubit.state.canDelete, isTrue);
      },
    );

    blocTest<WalletFormCubit, WalletFormState>(
      "the only wallet can't be deleted",
      setUp: () => when(() => wallets.watchSummaries(any())).thenAnswer((_) => Stream.value(Right([_summary(1)]))),
      build: () => build(id: 1),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.canDelete, isFalse);
        expect(cubit.state.others, isEmpty);
      },
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'deleting moves the rows to the chosen wallet',
      setUp: () => when(() => delete(2, moveTo: any(named: 'moveTo'))).thenAnswer((_) async => const Right(unit)),
      build: () => build(id: 2),
      act: (cubit) async {
        await cubit.load();
        await cubit.delete(moveTo: 1);
      },
      verify: (cubit) {
        expect(cubit.state.status, WalletFormStatus.deleted);
        verify(() => delete(2, moveTo: 1)).called(1);
      },
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'a refused delete comes back with its failure',
      setUp: () => when(() => delete(2, moveTo: any(named: 'moveTo'))).thenAnswer(
        (_) async => const Left(Failure.validation(field: 'wallet', reason: ValidationReason.lastWallet)),
      ),
      build: () => build(id: 2),
      act: (cubit) async {
        await cubit.load();
        await cubit.delete();
      },
      verify: (cubit) {
        expect(cubit.state.status, WalletFormStatus.ready);
        expect(cubit.state.failure, const Failure.validation(field: 'wallet', reason: ValidationReason.lastWallet));
      },
    );

    blocTest<WalletFormCubit, WalletFormState>(
      "a new wallet can't be deleted",
      build: build,
      act: (cubit) async {
        await cubit.load();
        await cubit.delete();
      },
      verify: (_) => verifyNever(() => delete(any(), moveTo: any(named: 'moveTo'))),
    );

    blocTest<WalletFormCubit, WalletFormState>(
      'a wallet that is gone fails to load',
      setUp: () => when(() => wallets.getById(9)).thenAnswer((_) async => const Left(Failure.notFound())),
      build: () => build(id: 9),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.status, WalletFormStatus.loadFailure);
        expect(cubit.state.failure, const Failure.notFound());
      },
    );
  });
}
