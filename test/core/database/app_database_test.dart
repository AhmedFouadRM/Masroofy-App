import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/local_date.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
  });
  tearDown(() => db.close());

  Future<int> categoryId(String seedKey) async =>
      (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals(seedKey))).getSingle()).id;

  Future<int> insertExpense({
    required int category,
    int amountMinor = 1000,
    LocalDate? date,
    int? recurringId,
    LocalDate? occurrence,
    InsertMode mode = InsertMode.insert,
  }) => db
      .into(db.expensesTable)
      .insert(
        ExpensesTableCompanion.insert(
          amountMinor: amountMinor,
          categoryId: category,
          date: date ?? LocalDate(2026, 10, 8),
          recurringExpenseId: Value(recurringId),
          occurrenceDate: Value(occurrence),
        ),
        mode: mode,
      );

  Future<int> insertTemplate(int category, {int amountMinor = 1000}) => db
      .into(db.recurringExpensesTable)
      .insert(
        RecurringExpensesTableCompanion.insert(
          title: 'Rent',
          amountMinor: amountMinor,
          categoryId: category,
          frequency: 'monthly',
          startDate: LocalDate(2026, 1, 31),
          nextDueDate: LocalDate(2026, 2, 28),
        ),
      );

  Future<int> insertCustomCategory(String name) => db
      .into(db.categoriesTable)
      .insert(
        CategoriesTableCompanion.insert(name: Value(name), icon: 'pets', color: 0xFF000000, sortOrder: 8),
      );

  group('seeding', () {
    test('creates the 8 expense and 6 income default categories in order, keyed by seed_key', () async {
      final rows = await (db.select(db.categoriesTable)..orderBy([(c) => OrderingTerm(expression: c.sortOrder)])).get();
      expect(rows.map((r) => r.seedKey), [
        'food',
        'transport',
        'shopping',
        'bills',
        'health',
        'entertainment',
        'education',
        DefaultCategories.otherSeedKey,
        'salary',
        'freelance',
        'gifts',
        'refunds',
        'investments',
        DefaultCategories.otherIncomeSeedKey,
      ]);
      expect(rows.map((r) => r.sortOrder), List.generate(14, (i) => i));
      expect(rows.every((r) => r.name == null && !r.isHidden), isTrue);
      expect(rows.take(8).every((r) => r.kind == 'expense'), isTrue);
      expect(rows.skip(8).every((r) => r.kind == 'income'), isTrue);
    });

    test('re-seeding is idempotent', () async {
      await db.seedDefaultCategories();
      expect(await db.select(db.categoriesTable).get(), hasLength(14));
    });

    test('a custom category defaults to the expense kind', () async {
      final id = await insertCustomCategory('Pets');
      expect((await (db.select(db.categoriesTable)..where((c) => c.id.equals(id))).getSingle()).kind, 'expense');
    });
  });

  group('constraints', () {
    test('foreign keys are enforced on every connection', () async {
      final row = await db.customSelect('PRAGMA foreign_keys').getSingle();
      expect(row.data.values.single, 1);
    });

    test('a category needs exactly one of seed_key / name', () async {
      await expectLater(
        db
            .into(db.categoriesTable)
            .insert(
              CategoriesTableCompanion.insert(icon: 'x', color: 0, sortOrder: 9),
            ),
        throwsA(isA<SqliteException>()),
      );
      await expectLater(
        db
            .into(db.categoriesTable)
            .insert(
              CategoriesTableCompanion.insert(
                seedKey: const Value('pets'),
                name: const Value('Pets'),
                icon: 'x',
                color: 0,
                sortOrder: 9,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
      expect(await insertCustomCategory('Pets'), greaterThan(0));
    });

    test('a category kind must be expense or income', () async {
      await expectLater(
        db
            .into(db.categoriesTable)
            .insert(
              CategoriesTableCompanion.insert(
                name: const Value('Pets'),
                kind: const Value('transfer'),
                icon: 'x',
                color: 0,
                sortOrder: 9,
              ),
            ),
        throwsA(isA<SqliteException>()),
      );
    });

    test('amounts must be positive', () async {
      final food = await categoryId('food');
      await expectLater(insertExpense(category: food, amountMinor: 0), throwsA(isA<SqliteException>()));
      await expectLater(insertTemplate(food, amountMinor: -1), throwsA(isA<SqliteException>()));
    });

    test('a template generates at most one expense per occurrence date', () async {
      final bills = await categoryId('bills');
      final template = await insertTemplate(bills);
      final due = LocalDate(2026, 2, 28);

      await insertExpense(category: bills, recurringId: template, occurrence: due);
      await insertExpense(category: bills, recurringId: template, occurrence: due, mode: InsertMode.insertOrIgnore);
      await expectLater(
        insertExpense(category: bills, recurringId: template, occurrence: due),
        throwsA(isA<SqliteException>()),
      );
      expect(await db.select(db.expensesTable).get(), hasLength(1));

      // Manual entries (no template) on the same day never conflict.
      await insertExpense(category: bills, date: due);
      await insertExpense(category: bills, date: due);
      expect(await db.select(db.expensesTable).get(), hasLength(3));
    });
  });

  group('delete behaviour', () {
    test('a category in use by expenses cannot be deleted', () async {
      final pets = await insertCustomCategory('Pets');
      await insertExpense(category: pets);
      await expectLater(
        (db.delete(db.categoriesTable)..where((c) => c.id.equals(pets))).go(),
        throwsA(isA<SqliteException>()),
      );
    });

    test('deleting a category deletes its budget', () async {
      final pets = await insertCustomCategory('Pets');
      await db
          .into(db.budgetsTable)
          .insert(
            BudgetsTableCompanion.insert(categoryId: pets, limitMinor: 50000, period: 'monthly'),
          );
      await (db.delete(db.categoriesTable)..where((c) => c.id.equals(pets))).go();
      expect(await db.select(db.budgetsTable).get(), isEmpty);
    });

    test('deleting a template keeps its expenses and their occurrence date', () async {
      final bills = await categoryId('bills');
      final template = await insertTemplate(bills);
      await insertExpense(category: bills, recurringId: template, occurrence: LocalDate(2026, 2, 28));

      await (db.delete(db.recurringExpensesTable)..where((t) => t.id.equals(template))).go();

      final expense = await db.select(db.expensesTable).getSingle();
      expect(expense.recurringExpenseId, isNull);
      expect(expense.occurrenceDate, LocalDate(2026, 2, 28));
    });
  });

  test('calendar dates are stored as YYYY-MM-DD text and round-trip', () async {
    await insertExpense(category: await categoryId('food'), date: LocalDate(2026, 3, 9));
    final raw = await db.customSelect('SELECT date FROM expenses').getSingle();
    expect(raw.data['date'], '2026-03-09');
    expect((await db.select(db.expensesTable).getSingle()).date, LocalDate(2026, 3, 9));
  });

  group('rescaleAmounts', () {
    test('adds a digit across expenses, templates and budgets', () async {
      final food = await categoryId('food');
      await insertExpense(category: food, amountMinor: 1250);
      await insertTemplate(food, amountMinor: 1250);
      await db
          .into(db.budgetsTable)
          .insert(
            BudgetsTableCompanion.insert(categoryId: food, limitMinor: 1250, period: 'weekly'),
          );

      await db.rescaleAmounts(fromDigits: 2, toDigits: 3);

      expect((await db.select(db.expensesTable).getSingle()).amountMinor, 12500);
      expect((await db.select(db.recurringExpensesTable).getSingle()).amountMinor, 12500);
      expect((await db.select(db.budgetsTable).getSingle()).limitMinor, 12500);
    });

    test('dropping a digit rounds, and never goes below one minor unit', () async {
      final food = await categoryId('food');
      await insertExpense(category: food, amountMinor: 12505);
      await insertExpense(category: food, amountMinor: 4);

      await db.rescaleAmounts(fromDigits: 3, toDigits: 2);

      final amounts = (await db.select(db.expensesTable).get()).map((e) => e.amountMinor);
      expect(amounts, [1251, 1]);
    });
  });
}
