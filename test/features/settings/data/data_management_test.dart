import 'dart:convert';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/data/backup_codec.dart';
import 'package:masroofy/features/settings/data/datasources/data_management_local_datasource.dart';
import 'package:masroofy/features/settings/data/repositories/data_management_repository_impl.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart' show PreferenceKeys;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences preferences;
  late DataManagementLocalDatasource datasource;
  late DataManagementRepositoryImpl repository;

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
            categoryId: food,
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
            categoryId: gym,
            date: LocalDate(2026, 10, 1),
            recurringExpenseId: Value(template),
            occurrenceDate: Value(LocalDate(2026, 10, 1)),
          ),
        );
    await db
        .into(db.expensesTable)
        .insert(ExpensesTableCompanion.insert(amountMinor: 500, categoryId: food, date: LocalDate(2026, 9, 30)));
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

  Future<List<int>> counts() async => [
    (await db.select(db.expensesTable).get()).length,
    (await db.select(db.categoriesTable).get()).length,
    (await db.select(db.budgetsTable).get()).length,
    (await db.select(db.recurringExpensesTable).get()).length,
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
      expect(map['version'], 1);
      expect(map['exportedAt'], '2026-10-09T08:30:00.000Z');
      expect(map['preferences'], {'currency_code': 'KWD', 'theme_mode': 'dark', 'western_digits': true});
      expect(map['expenses'] as List, hasLength(3));
      expect(map['categories'] as List, hasLength(9));
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
              categoryId: (await (other.select(other.categoriesTable)..limit(1)).getSingle()).id,
              date: LocalDate(2020, 1, 1),
            ),
          );

      right(await otherRepository.restoreBackup(json));
      final restored = await DataManagementLocalDatasource(other).readSnapshot();

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
      expect(preview.categories, 9);
      expect(preview.budgets, 1);
      expect(preview.recurring, 1);
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
    test('a newer version', () => expectRejected((m) => m['version'] = 2));
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
  });

  test('a database error while restoring rolls everything back', () async {
    await fillWithData();
    final before = await datasource.readSnapshot();
    final food = before.categories.firstWhere((c) => c.seedKey == 'food');
    // Passes the type checks but breaks a UNIQUE constraint.
    final broken = BackupSnapshot(
      categories: [food],
      recurring: const [],
      expenses: [before.expenses.first, before.expenses.first],
      budgets: const [],
    );

    await expectLater(datasource.replaceAll(broken), throwsA(anything));

    final after = await datasource.readSnapshot();
    expect(after.expenses, before.expenses);
    expect(after.categories, before.categories);
    expect(after.budgets, before.budgets);
    expect(after.recurring, before.recurring);
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
