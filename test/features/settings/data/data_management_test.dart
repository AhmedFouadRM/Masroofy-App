import 'dart:convert';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/data/backup_codec.dart';
import 'package:masroofy/features/settings/data/datasources/data_management_local_datasource.dart';
import 'package:masroofy/features/settings/data/repositories/data_management_repository_impl.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart' show PreferenceKeys;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/db_rows.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences preferences;
  late DataManagementLocalDatasource datasource;
  late DataManagementRepositoryImpl repository;
  late int me;

  final exportedAt = DateTime.utc(2026, 10, 9, 8, 30);

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({
      PreferenceKeys.currencyCode: 'KWD',
      PreferenceKeys.themeMode: 'dark',
      PreferenceKeys.westernDigits: true,
      // Never part of a backup.
      PreferenceKeys.authEnabled: true,
      PreferenceKeys.biometricEnabled: true,
    });
    preferences = await SharedPreferences.getInstance();
    me = await db.seedDefaultWallet();
    datasource = DataManagementLocalDatasource(db);
    repository = DataManagementRepositoryImpl(datasource, preferences, now: () => exportedAt);
  });
  tearDown(() => db.close());

  T right<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));

  Future<int> seed(String key) async =>
      (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals(key))).getSingle()).id;

  /// A custom category, a template, a manual and a generated expense, and a budget.
  Future<void> fillWithData() async {
    final food = await seed('food');
    final gym = await db
        .into(db.categoriesTable)
        .insert(
          CategoriesTableCompanion.insert(
            name: const Value('Gym'),
            icon: 'fitness_center',
            color: 0xFF112233,
            sortOrder: 20,
          ),
        );
    final template = await db
        .into(db.recurringExpensesTable)
        .insert(
          RecurringExpensesTableCompanion.insert(
            title: 'Gym fee',
            amountMinor: 120000,
            walletId: me,
            categoryId: gym,
            frequency: 'monthly',
            startDate: LocalDate(2026, 9, 1),
            nextDueDate: LocalDate(2026, 11, 1),
          ),
        );
    await db
        .into(db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(
            amountMinor: 1250,
            walletId: me,
            categoryId: Value(food),
            date: LocalDate(2026, 10, 8),
            title: const Value('Lunch, "friends"'),
            note: const Value('two\nlines'),
          ),
        );
    await db
        .into(db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(
            amountMinor: 120000,
            walletId: me,
            categoryId: Value(gym),
            date: LocalDate(2026, 10, 1),
            recurringExpenseId: Value(template),
            occurrenceDate: Value(LocalDate(2026, 10, 1)),
          ),
        );
    await db
        .into(db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(
            amountMinor: 500,
            walletId: me,
            categoryId: Value(food),
            date: LocalDate(2026, 9, 30),
          ),
        );
    await db
        .into(db.budgetsTable)
        .insert(
          BudgetsTableCompanion.insert(
            categoryId: food,
            limitMinor: 300000,
            period: 'monthly',
            lastAlertedPeriodStart: Value(LocalDate(2026, 10, 1)),
          ),
        );
  }

  /// A second wallet, Son, with a 500 transfer from Me, an expense and a template of his own.
  /// Returns Son's id.
  Future<int> fillWithWallets() async {
    final son = await addWallet(db, 'Son', icon: 'child', color: 0xFF3B82F6);
    await addTransferRows(
      db,
      from: me,
      to: son,
      amountMinor: 50000,
      date: LocalDate(2026, 10, 5),
      note: 'Pocket money',
    );
    await db
        .into(db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(
            amountMinor: 700,
            walletId: son,
            categoryId: Value(await seed('food')),
            date: LocalDate(2026, 10, 6),
          ),
        );
    await db
        .into(db.recurringExpensesTable)
        .insert(
          RecurringExpensesTableCompanion.insert(
            title: 'Pocket money',
            amountMinor: 20000,
            walletId: son,
            categoryId: await seed('food'),
            frequency: 'monthly',
            startDate: LocalDate(2026, 10, 1),
            nextDueDate: LocalDate(2026, 11, 1),
          ),
        );
    return son;
  }

  Future<List<int>> counts() async => [
    (await db.select(db.expensesTable).get()).length,
    (await db.select(db.categoriesTable).get()).length,
    (await db.select(db.budgetsTable).get()).length,
    (await db.select(db.recurringExpensesTable).get()).length,
    (await db.select(db.walletsTable).get()).length,
    (await db.select(db.transfersTable).get()).length,
  ];

  group('loadExpenseExport', () {
    test('lists every expense with its category, oldest first', () async {
      await fillWithData();

      final rows = right(await repository.loadExpenseExport());

      expect(rows.map((r) => r.date.toIso()), ['2026-09-30', '2026-10-01', '2026-10-08']);
      expect(rows.map((r) => r.isRecurring), [false, true, false]);
      expect(rows[1].categoryName, 'Gym');
      expect(rows[1].categorySeedKey, isNull);
      expect(rows[2].categorySeedKey, 'food');
      expect(rows[2].title, 'Lunch, "friends"');
      expect(rows[2].note, 'two\nlines');
      expect(rows[2].amount.minor, 1250);
    });

    test('names the wallet of every row', () async {
      await fillWithData();
      final son = await fillWithWallets();
      await db.update(db.expensesTable).write(const ExpensesTableCompanion(note: Value(null)));
      await (db.update(db.expensesTable)..where((e) => e.amountMinor.equals(500))).write(
        ExpensesTableCompanion(walletId: Value(son)),
      );

      final rows = right(await repository.loadExpenseExport());

      expect(rows.map((r) => (r.amount.minor, r.walletSeedKey, r.walletName)), [
        (500, null, 'Son'),
        (120000, 'me', null),
        (50000, 'me', null),
        (700, null, 'Son'),
        (1250, 'me', null),
      ]);
    });

    test('a transfer is one row, with its source and target wallet and no category', () async {
      await fillWithData();
      await fillWithWallets();

      final rows = right(await repository.loadExpenseExport());

      final transfers = rows.where((r) => r.isTransfer).toList();
      expect(transfers, hasLength(1));
      expect((transfers.single.amount.minor, transfers.single.date.toIso()), (50000, '2026-10-05'));
      expect((transfers.single.walletSeedKey, transfers.single.walletName), ('me', null));
      expect((transfers.single.toWalletSeedKey, transfers.single.toWalletName), (null, 'Son'));
      expect(
        (transfers.single.categorySeedKey, transfers.single.categoryName, transfers.single.note),
        (
          null,
          null,
          'Pocket money',
        ),
      );
      expect(rows, hasLength(5), reason: "three expenses, the son's expense and one transfer, not two");
      expect(
        rows.where((r) => !r.isTransfer).every((r) => r.toWalletName == null && r.toWalletSeedKey == null),
        isTrue,
      );
    });

    test('carries the kind of each row, with positive amounts', () async {
      await fillWithData();
      await db
          .into(db.expensesTable)
          .insert(
            ExpensesTableCompanion.insert(
              amountMinor: 500000,
              walletId: me,
              categoryId: Value(await seed('salary')),
              date: LocalDate(2026, 10, 9),
            ),
          );

      final rows = right(await repository.loadExpenseExport());

      expect(rows.map((r) => r.kind), [
        TransactionKind.expense,
        TransactionKind.expense,
        TransactionKind.expense,
        TransactionKind.income,
      ]);
      expect(rows.last.categorySeedKey, 'salary');
      expect(rows.last.amount.minor, 500000);
    });

    test('is empty with no expenses', () async {
      expect(right(await repository.loadExpenseExport()), isEmpty);
    });
  });

  group('backup', () {
    test('is versioned JSON of all data and the preferences, without the lock', () async {
      await fillWithData();

      final json = right(await repository.createBackup());
      final map = jsonDecode(json) as Map<String, dynamic>;

      expect(map['format'], 'masroofy-backup');
      expect(map['version'], 4);
      expect(map['exportedAt'], '2026-10-09T08:30:00.000Z');
      expect(map['preferences'], {
        'currency_code': 'KWD',
        'theme_mode': 'dark',
        'western_digits': true,
        'default_wallet_id': me,
      });
      expect(map['wallets'] as List, hasLength(1));
      expect(map['transfers'] as List, isEmpty);
      expect(map['expenses'] as List, hasLength(3));
      expect(map['categories'] as List, hasLength(15));
      expect(
        (map['categories'] as List).map((c) => (c as Map)['kind']),
        [...List.filled(8, 'expense'), ...List.filled(6, 'income'), 'expense'],
      );
      expect(map['budgets'] as List, hasLength(1));
      expect(map['recurringExpenses'] as List, hasLength(1));
      expect(json, isNot(contains('auth_enabled')));
      expect(json, isNot(contains('biometric')));
      expect(json, isNot(contains('pin_')));
    });

    test('defaults the preferences that were never set', () async {
      SharedPreferences.setMockInitialValues({});
      final fresh = await SharedPreferences.getInstance();
      final json = right(await DataManagementRepositoryImpl(datasource, fresh).createBackup());

      expect((jsonDecode(json) as Map<String, dynamic>)['preferences'], {
        'currency_code': 'EGP',
        'theme_mode': 'system',
        'western_digits': false,
        'default_wallet_id': me,
      });
    });

    test('round trip: restoring into another database reproduces every row', () async {
      await fillWithData();
      final json = right(await repository.createBackup());
      final original = await datasource.readSnapshot();

      final other = AppDatabase(NativeDatabase.memory());
      addTearDown(other.close);
      SharedPreferences.setMockInitialValues({});
      final otherPreferences = await SharedPreferences.getInstance();
      final otherRepository = DataManagementRepositoryImpl(DataManagementLocalDatasource(other), otherPreferences);
      // The target already holds unrelated data, which must go.
      await other
          .into(other.expensesTable)
          .insert(
            ExpensesTableCompanion.insert(
              amountMinor: 7,
              walletId: await other.seedDefaultWallet(),
              categoryId: Value((await (other.select(other.categoriesTable)..limit(1)).getSingle()).id),
              date: LocalDate(2020, 1, 1),
            ),
          );

      right(await otherRepository.restoreBackup(json));
      final restored = await DataManagementLocalDatasource(other).readSnapshot();

      expect(restored.wallets, original.wallets);
      expect(restored.transfers, original.transfers);
      expect(restored.categories, original.categories);
      expect(restored.recurring, original.recurring);
      expect(restored.expenses, original.expenses);
      expect(restored.budgets, original.budgets);
      expect(otherPreferences.getString(PreferenceKeys.currencyCode), 'KWD');
      expect(otherPreferences.getString(PreferenceKeys.themeMode), 'dark');
      expect(otherPreferences.getBool(PreferenceKeys.westernDigits), isTrue);
    });

    test('restore keeps the lock settings of this device', () async {
      final json = right(await repository.createBackup());
      await preferences.setBool(PreferenceKeys.authEnabled, false);

      right(await repository.restoreBackup(json));

      expect(preferences.getBool(PreferenceKeys.authEnabled), isFalse);
    });

    test('a backup round-trips the kinds', () async {
      await fillWithData();
      final tips = await db
          .into(db.categoriesTable)
          .insert(
            CategoriesTableCompanion.insert(
              name: const Value('Tips'),
              kind: const Value('income'),
              icon: 'savings',
              color: 0xFF445566,
              sortOrder: 21,
            ),
          );
      final before = await db.select(db.categoriesTable).get();
      final json = right(await repository.createBackup());
      await repository.clearAllData();

      right(await repository.restoreBackup(json));

      final after = await db.select(db.categoriesTable).get();
      expect(after.map((c) => (c.seedKey ?? c.name, c.kind)), before.map((c) => (c.seedKey ?? c.name, c.kind)));
      expect(after.firstWhere((c) => c.id == tips).kind, 'income');
    });

    test('a version 1 backup restores with every category as an expense category, all in Me', () async {
      await fillWithData();
      final json = right(await repository.createBackup());
      final map = jsonDecode(json) as Map<String, dynamic>;
      // What a version 1 file looked like: no kind, and no income categories.
      map['version'] = 1;
      map['categories'] = [
        for (final c in (map['categories'] as List).cast<Map<String, dynamic>>())
          if (c['kind'] == 'expense') {...c}..remove('kind'),
      ];
      final v1 = jsonEncode(map);
      expect(right(repository.previewBackup(v1)).categories, 9);

      right(await repository.restoreBackup(v1));

      final categories = await db.select(db.categoriesTable).get();
      expect(categories.where((c) => c.kind == 'expense'), hasLength(9));
      expect(categories.where((c) => c.seedKey == 'food').single.kind, 'expense');
      expect(categories.where((c) => c.name == 'Gym').single.kind, 'expense');
      // The income defaults are added back, as income categories.
      expect(categories.where((c) => c.kind == 'income').map((c) => c.seedKey), [
        'salary',
        'freelance',
        'gifts',
        'refunds',
        'investments',
        'other_income',
      ]);
      expect(await db.select(db.expensesTable).get(), hasLength(3));
      expect((await db.select(db.walletsTable).get()).map((w) => w.seedKey), ['me']);
    });

    test('restoring a backup that lacks a default category re-seeds it', () async {
      final json = right(await repository.createBackup());
      final map = jsonDecode(json) as Map<String, dynamic>;
      final categories = (map['categories'] as List).cast<Map<String, dynamic>>()
        ..removeWhere((c) => c['seedKey'] == 'other');
      map['categories'] = categories;

      right(await repository.restoreBackup(jsonEncode(map)));

      expect(await seed('other'), isPositive);
    });

    test('preview reports what the file holds', () async {
      await fillWithData();
      final preview = right(repository.previewBackup(right(await repository.createBackup())));

      expect(preview.exportedAt, exportedAt);
      expect(preview.expenses, 3);
      expect(preview.categories, 15);
      expect(preview.budgets, 1);
      expect(preview.recurring, 1);
    });
  });

  group('backup version 3: wallets', () {
    late int son;

    setUp(() async {
      await fillWithData();
      son = await fillWithWallets();
    });

    test("carries the wallets, the transfers and each row's wallet and leg", () async {
      await preferences.setInt(PreferenceKeys.defaultWalletId, son);

      final map = jsonDecode(right(await repository.createBackup())) as Map<String, dynamic>;

      expect(map['version'], 4);
      expect((map['preferences'] as Map)['default_wallet_id'], son);
      final wallets = (map['wallets'] as List).cast<Map<String, dynamic>>();
      expect(wallets.map((w) => (w['id'], w['seedKey'], w['name'], w['icon'])), [
        (me, 'me', null, 'person'),
        (son, null, 'Son', 'child'),
      ]);
      expect(map['transfers'] as List, hasLength(1));
      final expenses = (map['expenses'] as List).cast<Map<String, dynamic>>();
      final legs = expenses.where((e) => e['transferId'] != null).toList();
      expect(legs.map((e) => (e['direction'], e['walletId'], e['categoryId'])), [('out', me, null), ('in', son, null)]);
      expect(expenses.where((e) => e['transferId'] == null).every((e) => e['direction'] == null), isTrue);
      expect((map['recurringExpenses'] as List).cast<Map<String, dynamic>>().map((t) => t['walletId']), [me, son]);
    });

    test('round trip: wallets, transfers and the default come back as they were', () async {
      await preferences.setInt(PreferenceKeys.defaultWalletId, son);
      final json = right(await repository.createBackup());
      final original = await datasource.readSnapshot();
      await repository.clearAllData();
      expect(await db.select(db.walletsTable).get(), hasLength(1));

      right(await repository.restoreBackup(json));

      final restored = await datasource.readSnapshot();
      expect(restored.wallets, original.wallets);
      expect(restored.transfers, original.transfers);
      expect(restored.expenses, original.expenses);
      expect(restored.recurring, original.recurring);
      expect(preferences.getInt(PreferenceKeys.defaultWalletId), son);
      expect(preferences.getInt(PreferenceKeys.viewedWalletId), son);
    });

    test('a restored transfer still lists once and deletes as one', () async {
      final json = right(await repository.createBackup());
      await repository.clearAllData();
      right(await repository.restoreBackup(json));

      expect(await db.select(db.transfersTable).get(), hasLength(1));
      await db.delete(db.transfersTable).go();
      expect((await db.select(db.expensesTable).get()).where((e) => e.transferId != null), isEmpty);
    });
  });

  group('backups from before wallets', () {
    setUp(fillWithData);

    /// A version 1 or 2 file: no wallets, no transfers, no wallet on any row.
    Future<String> older(int version) async {
      final map = (jsonDecode(right(await repository.createBackup())) as Map<String, dynamic>)
        ..['version'] = version
        ..remove('wallets')
        ..remove('transfers')
        ..remove('merchantCategories')
        ..remove('trustedSenders');
      (map['preferences'] as Map<String, dynamic>).remove('default_wallet_id');
      final rows = [...(map['expenses'] as List), ...(map['recurringExpenses'] as List)];
      for (final row in rows.cast<Map<String, dynamic>>()) {
        row
          ..remove('walletId')
          ..remove('transferId')
          ..remove('direction')
          ..remove('source');
      }
      if (version == 1) {
        map['categories'] = [
          for (final c in (map['categories'] as List).cast<Map<String, dynamic>>())
            if (c['kind'] == 'expense') {...c}..remove('kind'),
        ];
      }
      return jsonEncode(map);
    }

    for (final version in [1, 2]) {
      test('a version $version backup restores into one wallet, Me, with everything in it', () async {
        final file = await older(version);
        await addWallet(db, 'Son');
        await repository.clearAllData();

        right(await repository.restoreBackup(file));

        final wallets = await db.select(db.walletsTable).get();
        expect(wallets.map((w) => (w.seedKey, w.name, w.icon, w.color, w.sortOrder)), [
          ('me', null, 'person', DefaultWallets.meColor, 0),
        ]);
        final id = wallets.single.id;
        expect((await db.select(db.expensesTable).get()).map((e) => e.walletId).toSet(), {id});
        expect((await db.select(db.recurringExpensesTable).get()).map((t) => t.walletId).toSet(), {id});
        expect(await db.select(db.transfersTable).get(), isEmpty);
        expect(preferences.getInt(PreferenceKeys.defaultWalletId), id);
        expect(preferences.getInt(PreferenceKeys.viewedWalletId), id);
        expect(right(repository.previewBackup(file)).expenses, 3);
      });
    }
  });

  group('backup version 4: SMS Import', () {
    late int uber;

    setUp(() async {
      await fillWithData();
      // The generated row, as the app stores it.
      await db.customStatement("UPDATE expenses SET source = 'recurring' WHERE recurring_expense_id IS NOT NULL");
      final food = await seed('food');
      final transport = await seed('transport');
      uber = transport;
      await db
          .into(db.merchantCategoriesTable)
          .insert(
            MerchantCategoriesTableCompanion.insert(merchantKey: 'uber', categoryId: transport),
          );
      await db
          .into(db.merchantCategoriesTable)
          .insert(
            MerchantCategoriesTableCompanion.insert(merchantKey: 'carrefour maadi', categoryId: food),
          );
      await db
          .into(db.trustedSendersTable)
          .insert(TrustedSendersTableCompanion.insert(sender: 'BANQUEMIS', trusted: true));
      await db.into(db.trustedSendersTable).insert(TrustedSendersTableCompanion.insert(sender: 'cib', trusted: false));
      // An SMS transaction, and its import row (which a backup leaves out).
      final expenseId = await db
          .into(db.expensesTable)
          .insert(
            ExpensesTableCompanion.insert(
              amountMinor: 500,
              walletId: me,
              categoryId: Value(transport),
              date: LocalDate(2026, 10, 9),
              title: const Value('Uber'),
              source: const Value('sms'),
            ),
          );
      await db
          .into(db.smsImportsTable)
          .insert(
            SmsImportsTableCompanion.insert(
              smsKey: 'abc',
              sender: 'EGBANK',
              receivedAt: DateTime.utc(2026, 10, 9, 12),
              kind: 'expense',
              amountMinor: 500,
              currency: 'EGP',
              date: LocalDate(2026, 10, 9),
              status: 'added',
              expenseId: Value(expenseId),
            ),
          );
    });

    test('carries the learned categories, the trusted senders and the source of each row, not the imports', () async {
      final map = jsonDecode(right(await repository.createBackup())) as Map<String, dynamic>;

      expect(map['version'], 4);
      expect(
        (map['merchantCategories'] as List).map((m) => ((m as Map)['merchantKey'], m['categoryId'])),
        [('carrefour maadi', await seed('food')), ('uber', uber)],
      );
      expect(
        (map['trustedSenders'] as List).map((t) => ((t as Map)['sender'], t['trusted'])),
        [('BANQUEMIS', true), ('cib', false)],
      );
      expect((map['expenses'] as List).map((e) => (e as Map)['source']).toSet(), {'manual', 'recurring', 'sms'});
      expect(map.keys, isNot(contains('smsImports')));
      expect(map.keys, isNot(contains('sms_imports')));
      expect(jsonEncode(map), isNot(contains('abc')));
    });

    test('round trip: restoring into another database brings them back, and no import history', () async {
      final json = right(await repository.createBackup());
      final other = AppDatabase(NativeDatabase.memory());
      addTearDown(other.close);
      await other.seedDefaultWallet();
      await other
          .into(other.trustedSendersTable)
          .insert(TrustedSendersTableCompanion.insert(sender: 'OLD', trusted: true));
      final target = DataManagementRepositoryImpl(
        DataManagementLocalDatasource(other),
        preferences,
        now: () => exportedAt,
      );

      right(await target.restoreBackup(json));

      expect(
        (await other.select(other.merchantCategoriesTable).get()).map((m) => (m.merchantKey, m.categoryId)),
        unorderedEquals([('carrefour maadi', await seed('food')), ('uber', uber)]),
      );
      expect(
        (await other.select(other.trustedSendersTable).get()).map((t) => (t.sender, t.trusted)),
        unorderedEquals([('BANQUEMIS', true), ('cib', false)]),
      );
      expect(await other.select(other.smsImportsTable).get(), isEmpty);
      final restored = await other.select(other.expensesTable).get();
      expect(restored.map((e) => e.source).toSet(), {'manual', 'recurring', 'sms'});
    });

    test('restoring replaces the learned categories and the senders of this device', () async {
      final json = right(await repository.createBackup());
      await db
          .into(db.merchantCategoriesTable)
          .insertOnConflictUpdate(
            MerchantCategoriesTableCompanion.insert(merchantKey: 'newer', categoryId: await seed('health')),
          );
      await db.into(db.trustedSendersTable).insert(TrustedSendersTableCompanion.insert(sender: 'NEWER', trusted: true));

      right(await repository.restoreBackup(json));

      expect((await db.select(db.merchantCategoriesTable).get()).map((m) => m.merchantKey), isNot(contains('newer')));
      expect((await db.select(db.trustedSendersTable).get()).map((t) => t.sender), isNot(contains('NEWER')));
      expect(await db.select(db.smsImportsTable).get(), isEmpty);
    });

    test('a version 3 backup restores with no SMS data and a source worked out from the template', () async {
      final map = (jsonDecode(right(await repository.createBackup())) as Map<String, dynamic>)
        ..['version'] = 3
        ..remove('merchantCategories')
        ..remove('trustedSenders');
      for (final row in (map['expenses'] as List).cast<Map<String, dynamic>>()) {
        row.remove('source');
      }

      right(await repository.restoreBackup(jsonEncode(map)));

      expect(await db.select(db.merchantCategoriesTable).get(), isEmpty);
      expect(await db.select(db.trustedSendersTable).get(), isEmpty);
      final sources = {
        for (final e in await db.select(db.expensesTable).get()) e.title ?? e.id: e.source,
      };
      // The generated row is `recurring`; the SMS row can't be told from a manual one.
      expect(sources.values.toSet(), {'manual', 'recurring'});
      expect((await db.select(db.expensesTable).get()).where((e) => e.source == 'recurring'), hasLength(1));
    });

    test('a version 3 backup is previewed too', () async {
      final map = (jsonDecode(right(await repository.createBackup())) as Map<String, dynamic>)
        ..['version'] = 3
        ..remove('merchantCategories')
        ..remove('trustedSenders');
      for (final row in (map['expenses'] as List).cast<Map<String, dynamic>>()) {
        row.remove('source');
      }

      expect(right(repository.previewBackup(jsonEncode(map))).expenses, 4);
    });

    group('a bad file is rejected', () {
      Future<void> expectRejected(void Function(Map<String, dynamic> map) corrupt) async {
        final map = jsonDecode(right(await repository.createBackup())) as Map<String, dynamic>;
        corrupt(map);
        final before = await db.select(db.merchantCategoriesTable).get();

        final result = await repository.restoreBackup(jsonEncode(map));

        expect(result.isLeft(), isTrue);
        expect(await db.select(db.merchantCategoriesTable).get(), before);
      }

      test('the SMS tables missing', () async {
        await expectRejected((m) => m.remove('merchantCategories'));
        await expectRejected((m) => m.remove('trustedSenders'));
      });

      test('a learned category for a category that is not in the file', () {
        return expectRejected((m) => ((m['merchantCategories'] as List).first as Map)['categoryId'] = 9999);
      });

      test('two categories for one merchant', () {
        return expectRejected(
          (m) => (m['merchantCategories'] as List).add({...(m['merchantCategories'] as List).first as Map}),
        );
      });

      test('an empty merchant', () {
        return expectRejected((m) => ((m['merchantCategories'] as List).first as Map)['merchantKey'] = '');
      });

      test('two answers for one sender', () {
        return expectRejected(
          (m) => (m['trustedSenders'] as List).add({...(m['trustedSenders'] as List).first as Map}),
        );
      });

      test('an answer that is not true or false', () {
        return expectRejected((m) => ((m['trustedSenders'] as List).first as Map)['trusted'] = 'yes');
      });

      test('a row with an unknown source', () {
        return expectRejected((m) => ((m['expenses'] as List).first as Map)['source'] = 'import');
      });

      test('a version 4 row without a source', () {
        return expectRejected((m) => ((m['expenses'] as List).first as Map).remove('source'));
      });
    });
  });

  group('restore rejects a bad file without touching anything', () {
    late Map<String, dynamic> good;

    setUp(() async {
      await fillWithData();
      good = jsonDecode(right(await repository.createBackup())) as Map<String, dynamic>;
    });

    Future<void> expectRejected(Object? Function(Map<String, dynamic> map) corrupt, {String? raw}) async {
      final before = await counts();
      final expensesBefore = await db.select(db.expensesTable).get();
      final copy = jsonDecode(jsonEncode(good)) as Map<String, dynamic>;
      final text = raw ?? jsonEncode(corrupt(copy) ?? copy);

      final result = await repository.restoreBackup(text);
      final preview = repository.previewBackup(text);

      expect(
        result,
        const Left<Failure, Unit>(Failure.validation(field: 'backup', reason: ValidationReason.invalidFormat)),
      );
      expect(preview.isLeft(), isTrue);
      expect(await counts(), before);
      expect(await db.select(db.expensesTable).get(), expensesBefore);
      expect(preferences.getString(PreferenceKeys.currencyCode), 'KWD');
    }

    test('not JSON', () => expectRejected((_) => null, raw: 'this is not json'));
    test('an empty file', () => expectRejected((_) => null, raw: ''));
    test('JSON that is not an object', () => expectRejected((_) => null, raw: '[1, 2, 3]'));
    test('a file of another format', () => expectRejected((m) => m['format'] = 'something-else'));
    test('a newer version', () => expectRejected((m) => m['version'] = 5));
    test('version 0', () => expectRejected((m) => m['version'] = 0));
    test('no version', () => expectRejected((m) => m.remove('version')));
    test('a missing table', () => expectRejected((m) => m.remove('expenses')));
    test('a table of the wrong type', () => expectRejected((m) => m['budgets'] = 'none'));
    test('a row that is not an object', () => expectRejected((m) => (m['expenses'] as List).add(5)));
    test('an unknown currency', () => expectRejected((m) => (m['preferences'] as Map)['currency_code'] = 'XXX'));
    test('an unknown theme', () => expectRejected((m) => (m['preferences'] as Map)['theme_mode'] = 'purple'));
    test('a zero amount', () => expectRejected((m) => ((m['expenses'] as List).first as Map)['amountMinor'] = 0));
    test('a negative limit', () => expectRejected((m) => ((m['budgets'] as List).first as Map)['limitMinor'] = -5));
    test('an amount that is not an integer', () {
      return expectRejected((m) => ((m['expenses'] as List).first as Map)['amountMinor'] = '12');
    });
    test(
      'an impossible date',
      () => expectRejected((m) => ((m['expenses'] as List).first as Map)['date'] = '2026-02-30'),
    );
    test(
      'a date in another format',
      () => expectRejected((m) => ((m['expenses'] as List).first as Map)['date'] = '9/10/2026'),
    );
    test('an expense in a category that is not in the file', () {
      return expectRejected((m) => ((m['expenses'] as List).first as Map)['categoryId'] = 999);
    });
    test('an expense of an unknown template', () {
      return expectRejected((m) => ((m['expenses'] as List).first as Map)['recurringExpenseId'] = 999);
    });
    test(
      'a budget for an unknown category',
      () => expectRejected((m) => ((m['budgets'] as List).first as Map)['categoryId'] = 999),
    );
    test(
      'an unknown budget period',
      () => expectRejected((m) => ((m['budgets'] as List).first as Map)['period'] = 'daily'),
    );
    test('an unknown frequency', () {
      return expectRejected((m) => ((m['recurringExpenses'] as List).first as Map)['frequency'] = 'hourly');
    });
    test('duplicate row ids', () {
      return expectRejected(
        (m) => (m['expenses'] as List)[1] = Map<String, dynamic>.from((m['expenses'] as List)[0] as Map),
      );
    });
    test('two budgets for one category', () {
      return expectRejected(
        (m) => (m['budgets'] as List).add(Map<String, dynamic>.from((m['budgets'] as List)[0] as Map)..['id'] = 77),
      );
    });
    test('a category kind that is neither expense nor income', () {
      return expectRejected((m) => ((m['categories'] as List).first as Map)['kind'] = 'transfer');
    });
    test('a version 2 category without a kind', () {
      return expectRejected((m) => ((m['categories'] as List).first as Map).remove('kind'));
    });
    test('a category with both a seed key and a name', () {
      return expectRejected((m) => ((m['categories'] as List).first as Map)['name'] = 'Both');
    });
    test(
      'a category with neither',
      () => expectRejected((m) => ((m['categories'] as List).first as Map)['seedKey'] = null),
    );
    test(
      'a title that is too long',
      () => expectRejected((m) => ((m['expenses'] as List).first as Map)['title'] = 'x' * 101),
    );

    group('version 3', () {
      Map<String, dynamic> row(Map<String, dynamic> m, String table, int index) =>
          (m[table] as List)[index] as Map<String, dynamic>;

      setUp(() async {
        // Make the good file hold a second wallet and a transfer.
        await fillWithWallets();
        good = jsonDecode(right(await repository.createBackup())) as Map<String, dynamic>;
      });

      Map<String, dynamic> leg(Map<String, dynamic> m, String direction) =>
          (m['expenses'] as List).cast<Map<String, dynamic>>().firstWhere((e) => e['direction'] == direction);

      test('no wallets', () => expectRejected((m) => m['wallets'] = <Object>[]));
      test('the wallets missing', () => expectRejected((m) => m.remove('wallets')));
      test('the transfers missing', () => expectRejected((m) => m.remove('transfers')));
      test(
        'a wallet with both a seed key and a name',
        () => expectRejected((m) => row(m, 'wallets', 0)['name'] = 'Both'),
      );
      test('a wallet with neither', () => expectRejected((m) => row(m, 'wallets', 1)['name'] = null));
      test('a wallet name that is too long', () => expectRejected((m) => row(m, 'wallets', 1)['name'] = 'x' * 31));
      test('two wallets of the same name, ignoring case', () {
        return expectRejected((m) => (m['wallets'] as List).add({...row(m, 'wallets', 1), 'id': 77, 'name': 'SON'}));
      });
      test(
        'two wallets with the same id',
        () => expectRejected((m) => row(m, 'wallets', 1)['id'] = row(m, 'wallets', 0)['id']),
      );
      test('a default wallet that is not in the file', () {
        return expectRejected((m) => (m['preferences'] as Map)['default_wallet_id'] = 999);
      });
      test('no default wallet', () => expectRejected((m) => (m['preferences'] as Map).remove('default_wallet_id')));
      test('an expense in a wallet that is not in the file', () {
        return expectRejected((m) => row(m, 'expenses', 0)['walletId'] = 999);
      });
      test('a template in a wallet that is not in the file', () {
        return expectRejected((m) => row(m, 'recurringExpenses', 0)['walletId'] = 999);
      });
      test('a row without a wallet', () => expectRejected((m) => row(m, 'expenses', 0).remove('walletId')));
      test('a row with no category that is not a transfer leg', () {
        return expectRejected((m) => row(m, 'expenses', 0)['categoryId'] = null);
      });
      test('a transfer leg with a category', () => expectRejected((m) => leg(m, 'out')['categoryId'] = 1));
      test('a transfer leg without a direction', () => expectRejected((m) => leg(m, 'in')['direction'] = null));
      test('a direction other than out or in', () => expectRejected((m) => leg(m, 'in')['direction'] = 'sideways'));
      test('a direction on a row that is not a transfer leg', () {
        return expectRejected((m) => row(m, 'expenses', 0)['direction'] = 'out');
      });
      test(
        'a leg of a transfer that is not in the file',
        () => expectRejected((m) => leg(m, 'out')['transferId'] = 999),
      );
      test('a transfer with one leg only', () {
        return expectRejected((m) => (m['expenses'] as List).remove(leg(m, 'in')));
      });
      test('a transfer with two out legs', () => expectRejected((m) => leg(m, 'in')['direction'] = 'out'));
      test(
        'a transfer inside one wallet',
        () => expectRejected((m) => leg(m, 'in')['walletId'] = leg(m, 'out')['walletId']),
      );
      test(
        'a transfer whose legs disagree on the amount',
        () => expectRejected((m) => leg(m, 'in')['amountMinor'] = 1),
      );
      test(
        'a transfer whose legs disagree on the date',
        () => expectRejected((m) => leg(m, 'in')['date'] = '2026-01-01'),
      );
      test('a transfer without legs', () {
        return expectRejected(
          (m) => (m['transfers'] as List).add({
            'id': 99,
            'createdAt': '2026-10-09T00:00:00Z',
            'updatedAt': '2026-10-09T00:00:00Z',
          }),
        );
      });
    });
  });

  test('a database error while restoring rolls everything back', () async {
    await fillWithData();
    final before = await datasource.readSnapshot();
    final food = before.categories.firstWhere((c) => c.seedKey == 'food');
    // Passes the type checks but breaks a UNIQUE constraint.
    final broken = BackupSnapshot(
      wallets: before.wallets,
      categories: [food],
      recurring: const [],
      transfers: const [],
      expenses: [before.expenses.first, before.expenses.first],
      budgets: const [],
    );

    await expectLater(datasource.replaceAll(broken), throwsA(anything));

    final after = await datasource.readSnapshot();
    expect(after.expenses, before.expenses);
    expect(after.categories, before.categories);
    expect(after.budgets, before.budgets);
    expect(after.recurring, before.recurring);
    expect(after.wallets, before.wallets);
  });

  group('clearAllData', () {
    test('deletes expenses, custom categories, budgets and templates, and re-seeds the defaults', () async {
      await fillWithData();

      right(await repository.clearAllData());

      final categories = await db.select(db.categoriesTable).get();
      expect(await db.select(db.expensesTable).get(), isEmpty);
      expect(await db.select(db.budgetsTable).get(), isEmpty);
      expect(await db.select(db.recurringExpensesTable).get(), isEmpty);
      expect(categories.map((c) => c.seedKey), DefaultCategories.seeds.map((s) => s.seedKey));
      expect(categories.every((c) => c.name == null && !c.isHidden), isTrue);
    });

    test('deletes every wallet and transfer, then recreates Me as the default and viewed wallet', () async {
      await fillWithData();
      final son = await fillWithWallets();
      await preferences.setInt(PreferenceKeys.defaultWalletId, son);
      await preferences.setInt(PreferenceKeys.viewedWalletId, son);

      right(await repository.clearAllData());

      final wallets = await db.select(db.walletsTable).get();
      expect(wallets.map((w) => (w.seedKey, w.name, w.icon, w.sortOrder)), [('me', null, 'person', 0)]);
      expect(await db.select(db.transfersTable).get(), isEmpty);
      expect(await db.select(db.expensesTable).get(), isEmpty);
      expect(preferences.getInt(PreferenceKeys.defaultWalletId), wallets.single.id);
      expect(preferences.getInt(PreferenceKeys.viewedWalletId), wallets.single.id);
    });

    test('also clears SMS Import: its history, learned categories and sender answers', () async {
      await fillWithData();
      final transport = await seed('transport');
      final expenseId = (await db.select(db.expensesTable).get()).first.id;
      await db
          .into(db.merchantCategoriesTable)
          .insert(
            MerchantCategoriesTableCompanion.insert(merchantKey: 'uber', categoryId: transport),
          );
      await db
          .into(db.trustedSendersTable)
          .insert(TrustedSendersTableCompanion.insert(sender: 'BANQUEMIS', trusted: true));
      await db
          .into(db.smsImportsTable)
          .insert(
            SmsImportsTableCompanion.insert(
              smsKey: 'abc',
              sender: 'EGBANK',
              receivedAt: DateTime.utc(2026, 10, 9, 12),
              kind: 'expense',
              amountMinor: 500,
              currency: 'EGP',
              categoryId: Value(transport),
              date: LocalDate(2026, 10, 9),
              status: 'added',
              expenseId: Value(expenseId),
            ),
          );
      await db
          .into(db.smsImportsTable)
          .insert(
            SmsImportsTableCompanion.insert(
              smsKey: 'def',
              sender: 'EGBANK',
              receivedAt: DateTime.utc(2026, 10, 9, 13),
              kind: 'expense',
              amountMinor: 700,
              currency: 'EGP',
              date: LocalDate(2026, 10, 9),
              status: 'pending',
            ),
          );

      right(await repository.clearAllData());

      expect(await db.select(db.smsImportsTable).get(), isEmpty);
      expect(await db.select(db.merchantCategoriesTable).get(), isEmpty);
      expect(await db.select(db.trustedSendersTable).get(), isEmpty);
      expect(await db.select(db.expensesTable).get(), isEmpty);
    });

    test('keeps the preferences and App Lock', () async {
      await fillWithData();

      right(await repository.clearAllData());

      expect(preferences.getString(PreferenceKeys.currencyCode), 'KWD');
      expect(preferences.getString(PreferenceKeys.themeMode), 'dark');
      expect(preferences.getBool(PreferenceKeys.westernDigits), isTrue);
      expect(preferences.getBool(PreferenceKeys.authEnabled), isTrue);
      expect(preferences.getBool(PreferenceKeys.biometricEnabled), isTrue);
    });

    test('works on an empty database and can be repeated', () async {
      right(await repository.clearAllData());
      right(await repository.clearAllData());

      expect(await db.select(db.categoriesTable).get(), hasLength(DefaultCategories.seeds.length));
    });
  });
}
