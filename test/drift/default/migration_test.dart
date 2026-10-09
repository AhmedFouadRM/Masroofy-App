// dart format width=80
// ignore_for_file: unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/database/app_database.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;

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

      // Nothing else changed. Raw SQL: the table classes describe the newest schema.
      final expenses = await db
          .customSelect(
            'SELECT id, category_id, amount_minor, recurring_expense_id FROM expenses ORDER BY id',
          )
          .get();
      expect(
        expenses.map(
          (e) => (
            e.read<int>('id'),
            e.read<int>('category_id'),
            e.read<int>('amount_minor'),
          ),
        ),
        [
          (1, 1, 1250),
          (2, 9, 120000),
        ],
      );
      expect(expenses.last.read<int>('recurring_expense_id'), 1);
      expect(
        (await db
                .customSelect('SELECT amount_minor FROM recurring_expenses')
                .getSingle())
            .read<int>('amount_minor'),
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

  test(
    'v2 to v3 moves every expense and template into Me, keeps the rest and '
    'enforces the new constraints',
    () async {
      final schema = await verifier.schemaAt(2);
      final oldDb = v2.DatabaseAtV2(schema.newConnection());
      // A v2 database in use: defaults, a custom category, an income
      // category, a template, expenses (one generated, one income) and a budget.
      for (final (i, key) in ['food', 'other', 'salary'].indexed) {
        await oldDb.customStatement(
          'INSERT INTO categories (id, seed_key, kind, icon, color, sort_order) '
          "VALUES (${i + 1}, '$key', '${key == 'salary' ? 'income' : 'expense'}', 'more_horiz', 255, $i)",
        );
      }
      await oldDb.customStatement(
        'INSERT INTO categories (id, name, icon, color, sort_order) '
        "VALUES (4, 'Gym', 'fitness_center', 255, 3)",
      );
      await oldDb.customStatement(
        'INSERT INTO recurring_expenses (id, title, amount_minor, category_id, '
        'frequency, start_date, next_due_date) '
        "VALUES (1, 'Gym fee', 120000, 4, 'monthly', '2026-09-01', '2026-11-01')",
      );
      await oldDb.customStatement(
        'INSERT INTO expenses (id, title, amount_minor, category_id, date, note, '
        'recurring_expense_id, occurrence_date) VALUES '
        "(1, 'Lunch', 1250, 1, '2026-10-08', 'with Sam', NULL, NULL), "
        "(2, NULL, 120000, 4, '2026-10-01', NULL, 1, '2026-10-01'), "
        "(3, NULL, 500000, 3, '2026-10-02', NULL, NULL, NULL)",
      );
      await oldDb.customStatement(
        'INSERT INTO budgets (id, category_id, limit_minor, period) '
        "VALUES (1, 1, 300000, 'monthly')",
      );
      await oldDb.close();

      final db = AppDatabase(schema.newConnection());
      await verifier.migrateAndValidate(db, 3);

      // One wallet, Me, named from its seed key.
      final wallets = await db.select(db.walletsTable).get();
      expect(wallets, hasLength(1));
      final me = wallets.single;
      expect(me.seedKey, 'me');
      expect(me.name, equals(null));
      expect(me.icon, 'person');
      expect(me.color, DefaultWallets.meColor);
      expect(me.sortOrder, 0);

      // Every row and template moved into it; nothing else changed.
      final expenses = await (db.select(
        db.expensesTable,
      )..orderBy([(e) => OrderingTerm(expression: e.id)])).get();
      expect(
        expenses.map((e) => (e.id, e.categoryId, e.amountMinor, e.walletId)),
        [
          (1, 1, 1250, me.id),
          (2, 4, 120000, me.id),
          (3, 3, 500000, me.id),
        ],
      );
      expect(
        expenses.every((e) => e.transferId == null && e.direction == null),
        isTrue,
      );
      expect(expenses.first.title, 'Lunch');
      expect(expenses.first.note, 'with Sam');
      expect(expenses[1].recurringExpenseId, 1);
      expect(expenses[1].occurrenceDate?.toIso(), '2026-10-01');
      final template = await db.select(db.recurringExpensesTable).getSingle();
      expect(
        (template.amountMinor, template.walletId, template.categoryId),
        (120000, me.id, 4),
      );
      expect((await db.select(db.budgetsTable).getSingle()).limitMinor, 300000);
      expect(await db.select(db.categoriesTable).get(), hasLength(4));

      // Foreign keys hold, and the indexes survived the rebuild.
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
      final indexes = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'index' AND name IN "
            "('idx_expenses_date', 'idx_expenses_category_date', 'idx_expenses_wallet_date', "
            "'idx_wallets_sort_order', 'idx_recurring_active_due')",
          )
          .get();
      expect(indexes, hasLength(5));

      // The new constraints are enforced.
      Future<void> insertExpense(
        String columns,
        String values,
      ) => db.customStatement(
        "INSERT INTO expenses (amount_minor, date, wallet_id, $columns) VALUES (100, '2026-10-09', ${me.id}, $values)",
      );
      await db.customStatement('INSERT INTO transfers (id) VALUES (1)');
      // A leg has no category, but a direction.
      await insertExpense('transfer_id, direction', "1, 'out'");
      await insertExpense('transfer_id, direction', "1, 'in'");
      // No category on an ordinary row.
      await expectLater(
        insertExpense('category_id', 'NULL'),
        throwsA(anything),
      );
      // A category on a leg.
      await expectLater(
        insertExpense('category_id, transfer_id, direction', "1, 1, 'out'"),
        throwsA(anything),
      );
      // A direction on an ordinary row, and a leg without one.
      await expectLater(
        insertExpense('category_id, direction', "1, 'out'"),
        throwsA(anything),
      );
      await expectLater(insertExpense('transfer_id', '1'), throwsA(anything));
      await expectLater(
        insertExpense('transfer_id, direction', "1, 'sideways'"),
        throwsA(anything),
      );
      // Names are unique ignoring case, 1-30 characters, and a wallet has a
      // seed key or a name, never both.
      await db.customStatement(
        "INSERT INTO wallets (name, icon, color, sort_order) VALUES ('Son', 'child', 255, 1)",
      );
      await expectLater(
        db.customStatement(
          "INSERT INTO wallets (name, icon, color, sort_order) VALUES ('SON', 'child', 255, 2)",
        ),
        throwsA(anything),
      );
      await expectLater(
        db.customStatement(
          "INSERT INTO wallets (name, icon, color, sort_order) VALUES ('', 'child', 255, 2)",
        ),
        throwsA(anything),
      );
      await expectLater(
        db.customStatement(
          "INSERT INTO wallets (name, icon, color, sort_order) VALUES ('${'x' * 31}', 'child', 255, 2)",
        ),
        throwsA(anything),
      );
      await expectLater(
        db.customStatement(
          "INSERT INTO wallets (icon, color, sort_order) VALUES ('child', 255, 2)",
        ),
        throwsA(anything),
      );
      await expectLater(
        db.customStatement(
          "INSERT INTO wallets (seed_key, name, icon, color, sort_order) VALUES ('x', 'X', 'child', 255, 2)",
        ),
        throwsA(anything),
      );
      // Deleting a transfer deletes both legs; a wallet with rows can't go.
      await db.customStatement('DELETE FROM transfers WHERE id = 1');
      expect(await db.select(db.expensesTable).get(), hasLength(3));
      await expectLater(
        db.customStatement('DELETE FROM wallets WHERE id = ${me.id}'),
        throwsA(anything),
      );
      await db.close();
    },
  );
}
