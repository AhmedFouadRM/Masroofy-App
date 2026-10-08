import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:masroofy/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';

void main() {
  late AppDatabase db;
  late ExpenseRepositoryImpl repository;
  late SaveExpense save;
  late int food;
  late int transport;
  final today = LocalDate(2026, 10, 8);
  final october = ExpenseFilter(range: DateRange.monthToDate(today));

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repository = ExpenseRepositoryImpl(ExpenseLocalDatasource(db));
    save = SaveExpense(repository, today: () => today);
    Future<int> seed(String key) async =>
        (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals(key))).getSingle()).id;
    food = await seed('food');
    transport = await seed('transport');
  });
  tearDown(() => db.close());

  T right<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));
  Failure left<T>(Either<Failure, T> result) => result.getLeft().getOrElse(() => fail('expected Left'));

  Future<int> add(int minor, LocalDate date, {int? category, String? title, String? note}) async => right(
    await save(
      ExpenseDraft(amount: Money(minor), categoryId: category ?? food, date: date, title: title, note: note),
    ),
  );

  test('saves trimmed text, and empty text as null', () async {
    final id = await add(1250, today, title: '  Lunch ', note: '   ');
    final expense = right(await repository.getById(id));
    expect((expense.title, expense.note, expense.amount), ('Lunch', null, const Money(1250)));
  });

  test('rejects a future date', () async {
    final result = await save(ExpenseDraft(amount: const Money(1), categoryId: food, date: today.addDays(1)));
    expect(left(result), const Failure.validation(field: 'date', reason: ValidationReason.inFuture));
  });

  test('lists newest first within the range, and pages by limit', () async {
    final first = await add(100, LocalDate(2026, 10, 1));
    final second = await add(200, today);
    final third = await add(300, today);
    await add(400, LocalDate(2026, 9, 30)); // outside

    final all = right(await repository.watchExpenses(october, limit: 50).first);
    expect(all.map((e) => e.id), [third, second, first]);
    final page = right(await repository.watchExpenses(october, limit: 2).first);
    expect(page.map((e) => e.id), [third, second]);
  });

  test('filters by category and searches title and note case-insensitively', () async {
    final lunch = await add(100, today, title: 'Team LUNCH');
    final uber = await add(200, today, category: transport, note: 'uber to work');
    await add(300, today);

    Future<List<int>> ids(ExpenseFilter filter) async =>
        right(await repository.watchExpenses(filter, limit: 50).first).map((e) => e.id).toList();

    expect(await ids(october.copyWith(categoryId: transport)), [uber]);
    expect(await ids(october.copyWith(search: ' lunch ')), [lunch]);
    expect(await ids(october.copyWith(search: 'UBER')), [uber]);
    expect(await ids(october.copyWith(search: '%')), isEmpty, reason: 'no LIKE wildcards');
  });

  test('totals and daily totals follow the filter, with exact sums', () async {
    for (var i = 0; i < 100; i++) {
      await add(10, today); // 100 × 0.10
    }
    await add(250, LocalDate(2026, 10, 2), category: transport);

    expect(right(await repository.watchTotal(october).first), const Money(1250));
    expect(right(await repository.watchTotal(october.copyWith(categoryId: transport)).first), const Money(250));
    expect(right(await repository.watchDailyTotals(october).first), {
      today: const Money(1000),
      LocalDate(2026, 10, 2): const Money(250),
    });
  });

  test('the list stream updates after a change', () async {
    final counts = <int>[];
    final sub = repository.watchExpenses(october, limit: 50).listen((r) => counts.add(right(r).length));
    await pumpEventQueue();
    await add(100, today);
    await pumpEventQueue();
    await sub.cancel();
    expect(counts, [0, 1]);
  });

  test('updates and deletes, reporting a missing id', () async {
    final id = await add(100, today);
    right(
      await save(
        ExpenseDraft(amount: const Money(999), categoryId: transport, date: today),
        id: id,
      ),
    );
    final updated = right(await repository.getById(id));
    expect((updated.amount, updated.categoryId), (const Money(999), transport));

    right(await repository.delete(id));
    expect(left(await repository.delete(id)), const Failure.notFound());
    expect(
      left(await repository.update(id, ExpenseDraft(amount: const Money(1), categoryId: food, date: today))),
      const Failure.notFound(),
    );
  });

  test('an unknown category is a constraint failure', () async {
    final result = await save(ExpenseDraft(amount: const Money(1), categoryId: 999, date: today));
    expect(left(result), isA<ConstraintFailure>());
  });
}
