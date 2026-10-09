// dart format width=80
// ignore_for_file: unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/database/app_database.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test(
    'v1 to v2 keeps every row, marks the categories as expense and adds the '
    'income defaults',
    () async {
      final schema = await verifier.schemaAt(1);
      final oldDb = v1.DatabaseAtV1(schema.newConnection());
      // A v1 database in use: the 8 defaults, a custom category, a template,
      // expenses (one generated) and a budget.
      for (final (i, key) in [
        'food',
        'transport',
        'shopping',
        'bills',
        'health',
        'entertainment',
        'education',
        'other',
      ].indexed) {
        await oldDb.customStatement(
          'INSERT INTO categories (id, seed_key, icon, color, sort_order) '
          "VALUES (${i + 1}, '$key', 'more_horiz', 255, $i)",
        );
      }
      await oldDb.customStatement(
        'INSERT INTO categories (id, name, icon, color, sort_order) '
        "VALUES (9, 'Gym', 'fitness_center', 255, 8)",
      );
      await oldDb.customStatement(
        'INSERT INTO recurring_expenses (id, title, amount_minor, category_id, '
        'frequency, start_date, next_due_date) '
        "VALUES (1, 'Gym fee', 120000, 9, 'monthly', '2026-09-01', '2026-11-01')",
      );
      await oldDb.customStatement(
        'INSERT INTO expenses (id, title, amount_minor, category_id, date, '
        'recurring_expense_id, occurrence_date) VALUES '
        "(1, 'Lunch', 1250, 1, '2026-10-08', NULL, NULL), "
        "(2, NULL, 120000, 9, '2026-10-01', 1, '2026-10-01')",
      );
      await oldDb.customStatement(
        'INSERT INTO budgets (id, category_id, limit_minor, period) '
        "VALUES (1, 1, 300000, 'monthly')",
      );
      await oldDb.close();

      final db = AppDatabase(schema.newConnection());
      await verifier.migrateAndValidate(db, 2);

      final categories = await (db.select(
        db.categoriesTable,
      )..orderBy([(c) => OrderingTerm(expression: c.id)])).get();
      final old = categories.where((c) => c.id <= 9).toList();
      expect(old, hasLength(9));
      expect(old.every((c) => c.kind == 'expense'), isTrue);
      expect(old.last.name, 'Gym');

      // The income defaults are added, in order, after the existing ones.
      final income = categories.where((c) => c.kind == 'income').toList();
      expect(income.map((c) => c.seedKey), [
        'salary',
        'freelance',
        'gifts',
        'refunds',
        'investments',
        'other_income',
      ]);
      expect(income.map((c) => c.icon), [
        'payments',
        'work',
        'redeem',
        'currency_exchange',
        'trending_up',
        'more_horiz',
      ]);
      expect(income.map((c) => c.sortOrder), [8, 9, 10, 11, 12, 13]);
      expect(categories, hasLength(15));

      // Nothing else changed.
      final expenses = await db.select(db.expensesTable).get();
      expect(expenses.map((e) => (e.id, e.categoryId, e.amountMinor)), [
        (1, 1, 1250),
        (2, 9, 120000),
      ]);
      expect(expenses.last.recurringExpenseId, 1);
      expect(
        (await db.select(db.recurringExpensesTable).getSingle()).amountMinor,
        120000,
      );
      expect((await db.select(db.budgetsTable).getSingle()).limitMinor, 300000);

      // The new column and index are enforced.
      final index = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE name = 'idx_categories_kind'",
          )
          .get();
      expect(index, hasLength(1));
      await expectLater(
        db.customStatement(
          "UPDATE categories SET kind = 'transfer' WHERE id = 1",
        ),
        throwsA(anything),
      );
      await db.close();
    },
  );
}
