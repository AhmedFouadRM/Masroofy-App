import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/utils/date_utils.dart';
import 'package:masroofy/features/budgets/data/datasources/budget_local_datasource.dart';
import 'package:masroofy/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_draft.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/budgets/domain/usecases/save_budget.dart';
import 'package:masroofy/features/budgets/domain/usecases/take_new_budget_alerts.dart';
import 'package:masroofy/features/categories/data/datasources/category_local_datasource.dart';

import '../../../helpers/db_rows.dart';

void main() {
  late AppDatabase db;
  late BudgetRepositoryImpl repository;
  late SaveBudget save;
  late int food;
  late int transport;
  late int me;
  // Friday; in Egypt the week runs Saturday Oct 3 – Friday Oct 9.
  final today = LocalDate(2026, 10, 9);
  final egyptWeekStart = DateUtilsHelper.firstWeekdayFor(languageCode: 'ar', countryCode: 'EG');

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repository = BudgetRepositoryImpl(BudgetLocalDatasource(db));
    save = SaveBudget(repository);
    me = await db.seedDefaultWallet();
    Future<int> seed(String key) async =>
        (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals(key))).getSingle()).id;
    food = await seed('food');
    transport = await seed('transport');
  });
  tearDown(() => db.close());

  T right<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));

  Future<void> spend(int minor, int category, LocalDate date) => db
      .into(db.expensesTable)
      .insert(ExpensesTableCompanion.insert(amountMinor: minor, walletId: me, categoryId: Value(category), date: date));

  Future<List<BudgetProgress>> progress() async =>
      right(await repository.watchProgress(today, firstWeekday: egyptWeekStart).first);

  test('on an ar_EG device a weekly window starts on Saturday', () {
    expect(egyptWeekStart, DateTime.saturday);
    expect(
      BudgetPeriod.weekly.windowFor(today, firstWeekday: egyptWeekStart),
      DateRange(LocalDate(2026, 10, 3), LocalDate(2026, 10, 9)),
    );
    expect(
      BudgetPeriod.monthly.windowFor(today, firstWeekday: egyptWeekStart),
      DateRange(LocalDate(2026, 10, 1), LocalDate(2026, 10, 31)),
    );
  });

  test('each budget sums its category in its own window', () async {
    right(await save(BudgetDraft(categoryId: food, limit: const Money(10000), period: BudgetPeriod.weekly)));
    right(await save(BudgetDraft(categoryId: transport, limit: const Money(50000), period: BudgetPeriod.monthly)));
    await spend(1000, food, LocalDate(2026, 10, 2)); // Friday: last week
    await spend(2000, food, LocalDate(2026, 10, 3)); // Saturday: this week
    await spend(4000, transport, LocalDate(2026, 10, 2));
    await spend(8000, transport, LocalDate(2026, 9, 30)); // last month

    final [foodProgress, transportProgress] = await progress();
    expect((foodProgress.spent, foodProgress.periodStart), (const Money(2000), LocalDate(2026, 10, 3)));
    expect((transportProgress.spent, transportProgress.periodStart), (const Money(4000), LocalDate(2026, 10, 1)));
  });

  test('budgets are global: spending in every wallet counts, and transfers never do', () async {
    right(await save(BudgetDraft(categoryId: food, limit: const Money(10000), period: BudgetPeriod.monthly)));
    final son = await addWallet(db, 'Son');
    await spend(1000, food, today);
    await db
        .into(db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(amountMinor: 700, walletId: son, categoryId: Value(food), date: today),
        );
    expect((await progress()).single.spent, const Money(1700));

    // Moving money between wallets is not spending.
    await addTransferRows(db, from: me, to: son, amountMinor: 50000, date: today);
    expect((await progress()).single.spent, const Money(1700));
  });

  test('progress re-emits when an expense is added', () async {
    right(await save(BudgetDraft(categoryId: food, limit: const Money(10000), period: BudgetPeriod.monthly)));
    final spent = repository.watchProgress(today, firstWeekday: egyptWeekStart).map((r) => right(r).single.spent);
    final done = expectLater(spent, emitsInOrder([Money.zero, const Money(500)]));
    await Future<void>.delayed(Duration.zero);
    await spend(500, food, today);
    await done;
  });

  test('a second budget for the same category is a duplicate', () async {
    right(await save(BudgetDraft(categoryId: food, limit: const Money(1), period: BudgetPeriod.monthly)));
    final again = await save(BudgetDraft(categoryId: food, limit: const Money(2), period: BudgetPeriod.weekly));
    expect(
      again.getLeft().toNullable(),
      const Failure.validation(field: 'categoryId', reason: ValidationReason.duplicate),
    );
  });

  test('editing changes the limit and period, never the category', () async {
    final id = right(await save(BudgetDraft(categoryId: food, limit: const Money(1), period: BudgetPeriod.monthly)));
    right(
      await save(
        BudgetDraft(categoryId: transport, limit: const Money(9), period: BudgetPeriod.weekly),
        id: id,
      ),
    );
    final budget = right(await repository.getById(id));
    expect((budget.categoryId, budget.limit, budget.period), (food, const Money(9), BudgetPeriod.weekly));
  });

  test('the exceed alert fires once per window, and survives a restart', () async {
    right(await save(BudgetDraft(categoryId: food, limit: const Money(1000), period: BudgetPeriod.monthly)));
    final alerts = TakeNewBudgetAlerts(repository);

    await spend(1000, food, today); // exactly 100%: warning, no alert
    expect(await alerts(await progress()), isEmpty);

    await spend(1, food, today);
    expect((await alerts(await progress())).map((p) => p.budget.categoryId), [food]);
    // A later snapshot (or a fresh launch reading the marker) stays quiet.
    expect(await alerts(await progress()), isEmpty);

    // Next month is a new window.
    await spend(2000, food, LocalDate(2026, 11, 2));
    final november = right(await repository.watchProgress(LocalDate(2026, 11, 2), firstWeekday: egyptWeekStart).first);
    expect(await alerts(november), hasLength(1));
  });

  test('an income category cannot have a budget', () async {
    final salary = (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals('salary'))).getSingle()).id;

    final result = await save(BudgetDraft(categoryId: salary, limit: const Money(1000), period: BudgetPeriod.monthly));

    expect(
      result.getLeft().toNullable(),
      const Failure.validation(field: 'categoryId', reason: ValidationReason.invalidFormat),
    );
    expect(await progress(), isEmpty);
  });

  test('income never counts towards a budget', () async {
    right(await save(BudgetDraft(categoryId: food, limit: const Money(1000), period: BudgetPeriod.monthly)));
    final salary = (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals('salary'))).getSingle()).id;
    await spend(1000000, salary, today);
    await spend(400, food, today);

    expect((await progress()).single.spent, const Money(400));
  });

  test('deleting a category deletes its budget', () async {
    final categories = CategoryLocalDatasource(db);
    final gym = await categories.insertCategory(
      name: 'Gym',
      icon: 'fitness_center',
      color: 0xFF000000,
      kind: 'expense',
    );
    right(await save(BudgetDraft(categoryId: gym, limit: const Money(1), period: BudgetPeriod.monthly)));

    await categories.deleteCategory(gym);
    expect(await progress(), isEmpty);
  });
}
