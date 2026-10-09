import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/categories/data/datasources/category_local_datasource.dart';
import 'package:masroofy/features/categories/data/repositories/category_repository_impl.dart';
import 'package:masroofy/features/categories/domain/entities/category_draft.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/categories/domain/usecases/delete_category.dart';
import 'package:masroofy/features/categories/domain/usecases/save_category.dart';

class _FakeReservedNames implements IReservedCategoryNames {
  @override
  Future<Set<String>> load() async => {'Food', 'طعام', 'Other', 'أخرى'};
}

void main() {
  late AppDatabase db;
  late CategoryRepositoryImpl repository;
  late SaveCategory save;
  late DeleteCategory deleteCategory;
  late int me;

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    me = await db.seedDefaultWallet();
    repository = CategoryRepositoryImpl(CategoryLocalDatasource(db));
    save = SaveCategory(repository, _FakeReservedNames());
    deleteCategory = DeleteCategory(repository);
  });
  tearDown(() => db.close());

  T right<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));
  Failure left<T>(Either<Failure, T> result) => result.getLeft().getOrElse(() => fail('expected Left'));

  CategoryDraft draft(String name) => CategoryDraft(name: name, icon: 'pets', color: 0xFF26C6DA);

  Future<int> seedId(String key) async =>
      (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals(key))).getSingle()).id;

  Future<void> addExpense(int categoryId) => db
      .into(db.expensesTable)
      .insert(
        ExpensesTableCompanion.insert(
          amountMinor: 1000,
          walletId: me,
          categoryId: Value(categoryId),
          date: LocalDate(2026, 10, 8),
        ),
      );

  Future<void> addTemplate(int categoryId) => db
      .into(db.recurringExpensesTable)
      .insert(
        RecurringExpensesTableCompanion.insert(
          title: 'Membership',
          amountMinor: 30000,
          walletId: me,
          categoryId: categoryId,
          frequency: 'monthly',
          startDate: LocalDate(2026, 1, 1),
          nextDueDate: LocalDate(2026, 11, 1),
        ),
      );

  group('create', () {
    test('appends custom categories after the defaults, trimmed', () async {
      final gym = right(await save(draft('  My   Gym ')));
      final pets = right(await save(draft('Pets')));

      final all = right(await repository.watchAll().first);
      expect(all.take(14).every((c) => c.isDefault), isTrue);
      expect(all.skip(14).map((c) => c.id), [gym, pets]);
      expect(all[14].name, 'My Gym');
      expect(all[15].sortOrder, all[14].sortOrder + 1);
    });

    test('rejects names taken by custom or default categories', () async {
      right(await save(draft('Gym')));
      expect(
        left(await save(draft('GYM'))),
        const Failure.validation(field: 'name', reason: ValidationReason.duplicate),
      );
      expect(
        left(await save(draft('طعام'))),
        const Failure.validation(field: 'name', reason: ValidationReason.duplicate),
      );
    });
  });

  group('kind', () {
    test('a new category is an expense category unless it says income', () async {
      final gym = right(await save(draft('Gym')));
      final tips = right(await save(draft('Tips').copyWith(kind: TransactionKind.income)));

      expect(right(await repository.getById(gym)).kind, TransactionKind.expense);
      expect(right(await repository.getById(tips)).kind, TransactionKind.income);
    });

    test('the default income categories are income categories', () async {
      final all = right(await repository.watchAll().first);
      expect(all.where((c) => c.kind == TransactionKind.income).map((c) => c.seedKey), [
        'salary',
        'freelance',
        'gifts',
        'refunds',
        'investments',
        'other_income',
      ]);
    });

    test('an unused category can change kind', () async {
      final id = right(await save(draft('Gym')));
      right(await save(draft('Gym').copyWith(kind: TransactionKind.income), id: id));

      expect(right(await repository.getById(id)).kind, TransactionKind.income);
    });

    test('the kind is locked while an expense uses the category', () async {
      final id = right(await save(draft('Gym')));
      await addExpense(id);

      expect(
        left(await save(draft('Gym').copyWith(kind: TransactionKind.income), id: id)),
        const Failure.validation(field: 'kind', reason: ValidationReason.inUse),
      );
      expect(right(await repository.getById(id)).kind, TransactionKind.expense);
      // Saving the same kind is fine.
      right(await save(draft('Gym 2'), id: id));
    });

    test('the kind is locked while a recurring template uses the category', () async {
      final id = right(await save(draft('Gym')));
      await addTemplate(id);

      expect(
        left(await save(draft('Gym').copyWith(kind: TransactionKind.income), id: id)),
        const Failure.validation(field: 'kind', reason: ValidationReason.inUse),
      );
    });
  });

  group('update', () {
    test('may keep its own name and changes icon and colour', () async {
      final id = right(await save(draft('Gym')));
      right(
        await save(
          const CategoryDraft(name: 'gym', icon: 'fitness_center', color: 1),
          id: id,
        ),
      );

      final category = right(await repository.getById(id));
      expect((category.name, category.icon, category.color), ('gym', 'fitness_center', 1));
    });

    test('never touches a default category', () async {
      expect(left(await repository.update(await seedId('food'), draft('Meals'))), const Failure.notFound());
    });
  });

  test('summaries count expenses and templates and include the budget', () async {
    final gym = right(await save(draft('Gym')));
    await addExpense(gym);
    await addExpense(gym);
    await addTemplate(gym);
    await db
        .into(db.budgetsTable)
        .insert(BudgetsTableCompanion.insert(categoryId: gym, limitMinor: 200000, period: 'monthly'));

    final summary = right(await repository.getSummary(gym));
    expect(summary.expenseCount, 2);
    expect(summary.recurringCount, 1);
    expect(summary.budgetLimit, const Money(200000));
    expect(summary.budgetPeriod, BudgetPeriod.monthly);

    final food = right(await repository.getSummary(await seedId('food')));
    expect((food.expenseCount, food.budgetLimit, food.isInUse), (0, null, false));
  });

  test('the summaries stream updates after a change', () async {
    final stream = repository.watchSummaries().map((r) => right(r).length);
    final counts = <int>[];
    final sub = stream.listen(counts.add);
    await pumpEventQueue();
    right(await save(draft('Gym')));
    await pumpEventQueue();
    await sub.cancel();
    expect(counts, [14, 15]);
  });

  group('delete', () {
    test('moves expenses and templates to Other and removes the budget', () async {
      final gym = right(await save(draft('Gym')));
      await addExpense(gym);
      await addTemplate(gym);
      await db
          .into(db.budgetsTable)
          .insert(BudgetsTableCompanion.insert(categoryId: gym, limitMinor: 1000, period: 'weekly'));

      right(await deleteCategory(gym));

      final other = await seedId('other');
      expect((await db.select(db.expensesTable).getSingle()).categoryId, other);
      expect((await db.select(db.recurringExpensesTable).getSingle()).categoryId, other);
      expect(await db.select(db.budgetsTable).get(), isEmpty);
      expect(left(await repository.getById(gym)), const Failure.notFound());
    });

    test('an income category moves its rows and templates to Other income', () async {
      final tips = right(await save(draft('Tips').copyWith(kind: TransactionKind.income)));
      await addExpense(tips);
      await addTemplate(tips);

      right(await deleteCategory(tips));

      final otherIncome = await seedId('other_income');
      expect((await db.select(db.expensesTable).getSingle()).categoryId, otherIncome);
      expect((await db.select(db.recurringExpensesTable).getSingle()).categoryId, otherIncome);
    });

    test('Other income cannot be deleted', () async {
      expect(left(await deleteCategory(await seedId('other_income'))), isA<ConstraintFailure>());
    });

    test('refuses default categories', () async {
      expect(left(await deleteCategory(await seedId('other'))), isA<ConstraintFailure>());
      expect(left(await deleteCategory(await seedId('food'))), isA<ConstraintFailure>());
    });

    test('reports a missing category', () async {
      expect(left(await deleteCategory(999)), const Failure.notFound());
    });
  });
}
