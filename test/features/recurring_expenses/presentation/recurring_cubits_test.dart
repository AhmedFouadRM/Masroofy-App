import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_draft.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/delete_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/save_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/set_recurring_active.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_list_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockRecurring extends Mock implements IRecurringExpenseRepository {}

class _MockCategories extends Mock implements ICategoryRepository {}

class _MockSetActive extends Mock implements SetRecurringActive {}

class _MockDelete extends Mock implements DeleteRecurring {}

class _MockSave extends Mock implements SaveRecurring {}

final _today = LocalDate(2026, 10, 9);
final _epoch = DateTime.utc(2026, 10, 9);

RecurringExpense _template(int id, {bool active = true, TransactionKind kind = TransactionKind.expense}) =>
    RecurringExpense(
      id: id,
      title: 'Rent $id',
      amount: const Money(500000),
      categoryId: 1,
      frequency: RecurringFrequency.monthly,
      startDate: _today,
      nextDueDate: _today.addMonths(1),
      isActive: active,
      createdAt: _epoch,
      updatedAt: _epoch,
      kind: kind,
    );

final _salary = Category(
  id: 2,
  seedKey: 'salary',
  icon: 'payments',
  color: 0,
  sortOrder: 8,
  createdAt: _epoch,
  updatedAt: _epoch,
  kind: TransactionKind.income,
);

final _bills = Category(
  id: 1,
  seedKey: 'bills',
  icon: 'receipt_long',
  color: 0,
  sortOrder: 3,
  createdAt: _epoch,
  updatedAt: _epoch,
);

void main() {
  late _MockRecurring recurring;
  late _MockCategories categories;

  setUpAll(() {
    registerFallbackValue(
      RecurringDraft(
        title: '',
        amount: Money.zero,
        categoryId: 0,
        frequency: RecurringFrequency.monthly,
        startDate: _today,
      ),
    );
  });

  setUp(() {
    recurring = _MockRecurring();
    categories = _MockCategories();
    when(
      () => categories.watchAll(includeHidden: any(named: 'includeHidden')),
    ).thenAnswer((_) => Stream.value(Right([_bills])));
  });

  group('RecurringListCubit', () {
    late _MockSetActive setActive;
    late _MockDelete delete;

    setUp(() {
      setActive = _MockSetActive();
      delete = _MockDelete();
      when(
        () => recurring.watchAll(),
      ).thenAnswer((_) => Stream.value(Right([_template(1), _template(2, active: false)])));
    });

    RecurringListCubit build() => RecurringListCubit(recurring, categories, setActive, delete);

    blocTest<RecurringListCubit, RecurringListState>(
      'loads templates split into active and paused, with categories',
      build: build,
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.status, RecurringListStatus.loaded);
        expect(cubit.state.active.map((t) => t.id), [1]);
        expect(cubit.state.paused.map((t) => t.id), [2]);
        expect(cubit.state.categories[1], _bills);
      },
    );

    blocTest<RecurringListCubit, RecurringListState>(
      'pausing flips the row at once',
      build: build,
      setUp: () => when(() => setActive(1, active: false)).thenAnswer((_) async => const Right(unit)),
      act: (cubit) async {
        cubit.load();
        await Future<void>.delayed(Duration.zero);
        await cubit.setActive(1, active: false);
      },
      verify: (cubit) {
        expect(cubit.state.paused.map((t) => t.id), containsAll([1, 2]));
        verify(() => setActive(1, active: false)).called(1);
      },
    );

    blocTest<RecurringListCubit, RecurringListState>(
      'a failed delete restores the row and reports the failure',
      build: build,
      setUp: () => when(() => delete(1)).thenAnswer((_) async => const Left(Failure.storage(message: 'disk'))),
      act: (cubit) async {
        cubit.load();
        await Future<void>.delayed(Duration.zero);
        await cubit.delete(1);
      },
      verify: (cubit) {
        expect(cubit.state.templates.map((t) => t.id), [1, 2]);
        expect(cubit.state.actionFailure, const Failure.storage(message: 'disk'));
      },
    );
  });

  group('RecurringFormCubit', () {
    late _MockSave save;

    setUp(() => save = _MockSave());

    RecurringFormCubit build({int? id}) =>
        RecurringFormCubit(recurring, categories, save, fractionDigits: 2, recurringId: id, today: () => _today);

    blocTest<RecurringFormCubit, RecurringFormState>(
      'a new template starts today, monthly and active',
      build: build,
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(cubit.state.status, RecurringFormStatus.ready);
        expect(
          (cubit.state.startDate, cubit.state.frequency, cubit.state.isActive),
          (
            _today,
            RecurringFrequency.monthly,
            true,
          ),
        );
      },
    );

    blocTest<RecurringFormCubit, RecurringFormState>(
      'editing pre-fills every field',
      build: () => build(id: 2),
      setUp: () => when(() => recurring.getById(2)).thenAnswer((_) async => Right(_template(2, active: false))),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(
          (cubit.state.amountText, cubit.state.title, cubit.state.categoryId, cubit.state.isActive),
          (
            '5000.00',
            'Rent 2',
            1,
            false,
          ),
        );
      },
    );

    blocTest<RecurringFormCubit, RecurringFormState>(
      'switching to Income clears an expense category and offers income ones',
      build: build,
      setUp: () => when(() => categories.watchAll()).thenAnswer((_) => Stream.value(Right([_bills, _salary]))),
      act: (cubit) async {
        await cubit.load();
        cubit
          ..categorySelected(1)
          ..kindSelected(TransactionKind.income);
      },
      verify: (cubit) {
        expect(cubit.state.kind, TransactionKind.income);
        expect(cubit.state.categoryId, isNull);
        expect(cubit.state.pickerCategories, [_salary]);
      },
    );

    blocTest<RecurringFormCubit, RecurringFormState>(
      'a monthly salary saves as an income template',
      build: build,
      setUp: () {
        when(() => categories.watchAll()).thenAnswer((_) => Stream.value(Right([_bills, _salary])));
        when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(7));
      },
      act: (cubit) async {
        await cubit.load();
        cubit
          ..kindSelected(TransactionKind.income)
          ..amountChanged('15000')
          ..categorySelected(2)
          ..titleChanged('Salary');
        await cubit.save();
      },
      verify: (cubit) {
        final draft = verify(() => save(captureAny(), id: any(named: 'id'))).captured.single as RecurringDraft;
        expect((draft.kind, draft.categoryId, draft.amount), (TransactionKind.income, 2, const Money(1500000)));
      },
    );

    blocTest<RecurringFormCubit, RecurringFormState>(
      'editing an income template opens on Income',
      build: () => build(id: 5),
      setUp: () => when(() => recurring.getById(5)).thenAnswer(
        (_) async => Right(_template(5, kind: TransactionKind.income)),
      ),
      act: (cubit) => cubit.load(),
      verify: (cubit) => expect(cubit.state.kind, TransactionKind.income),
    );

    blocTest<RecurringFormCubit, RecurringFormState>(
      'saving without amount, category or title shows field errors',
      build: build,
      act: (cubit) async {
        await cubit.load();
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.errors.keys, containsAll(['amount', 'categoryId', 'title']));
        verifyNever(() => save(any(), id: any(named: 'id')));
      },
    );

    blocTest<RecurringFormCubit, RecurringFormState>(
      'saves the parsed draft',
      build: build,
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(7)),
      act: (cubit) async {
        await cubit.load();
        cubit
          ..amountChanged('١٢٥٫٥')
          ..categorySelected(1)
          ..titleChanged('Gym')
          ..frequencySelected(RecurringFrequency.weekly);
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.status, RecurringFormStatus.saved);
        final draft = verify(() => save(captureAny(), id: null)).captured.single as RecurringDraft;
        expect(
          draft,
          RecurringDraft(
            title: 'Gym',
            amount: const Money(12550),
            categoryId: 1,
            frequency: RecurringFrequency.weekly,
            startDate: _today,
          ),
        );
      },
    );
  });
}
