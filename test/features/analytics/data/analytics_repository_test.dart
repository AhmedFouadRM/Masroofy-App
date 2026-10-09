import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:masroofy/features/analytics/data/repositories/analytics_repository_impl.dart';

import '../../../helpers/db_rows.dart';

void main() {
  late AppDatabase db;
  late AnalyticsRepositoryImpl repository;
  late int food;
  late int transport;
  late int salary;
  late int me;
  late int son;
  final october = DateRange(LocalDate(2026, 10, 1), LocalDate(2026, 10, 31));

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repository = AnalyticsRepositoryImpl(AnalyticsLocalDatasource(db));
    me = await db.seedDefaultWallet();
    son = await addWallet(db, 'Son');
    Future<int> seed(String key) async =>
        (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals(key))).getSingle()).id;
    food = await seed('food');
    transport = await seed('transport');
    salary = await seed('salary');
    Future<void> add(int minor, int category, LocalDate date) => db
        .into(db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(amountMinor: minor, walletId: me, categoryId: Value(category), date: date),
        );
    await add(1000, food, LocalDate(2026, 10, 1));
    await add(500, food, LocalDate(2026, 10, 1));
    await add(300, transport, LocalDate(2026, 10, 5));
    await add(9999, food, LocalDate(2026, 9, 30)); // outside the range
    await add(500000, salary, LocalDate(2026, 10, 1));
    await add(20000, salary, LocalDate(2026, 10, 6));
  });
  tearDown(() => db.close());

  T first<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));

  test('totals income and spending of a range separately; spending ignores income', () async {
    final totals = first(await repository.watchTotals(october).first);
    expect(totals.spent, const Money(1800));
    expect(totals.income, const Money(520000));
    expect(totals.balance, const Money(518200));
  });

  test('an empty range totals zero', () async {
    final empty = DateRange(LocalDate(2026, 1, 1), LocalDate(2026, 1, 31));
    expect(first(await repository.watchTotals(empty).first), PeriodTotals.zero);
  });

  test('totals by category for a kind', () async {
    expect(first(await repository.watchTotalsByCategory(october, TransactionKind.expense).first), {
      food: const Money(1500),
      transport: const Money(300),
    });
    expect(first(await repository.watchTotalsByCategory(october, TransactionKind.income).first), {
      salary: const Money(520000),
    });
  });

  test('daily totals carry both series', () async {
    expect(first(await repository.watchDailyTotals(october).first), {
      LocalDate(2026, 10, 1): const PeriodTotals(income: Money(500000), spent: Money(1500)),
      LocalDate(2026, 10, 5): const PeriodTotals(income: Money.zero, spent: Money(300)),
      LocalDate(2026, 10, 6): const PeriodTotals(income: Money(20000), spent: Money.zero),
    });
  });

  test('re-emits when an expense is added', () async {
    final totals = repository.watchTotals(october).map(first).map((t) => t.spent);
    final done = expectLater(totals, emitsInOrder([const Money(1800), const Money(1900)]));
    await Future<void>.delayed(Duration.zero);
    await db
        .into(db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(
            amountMinor: 100,
            walletId: me,
            categoryId: Value(food),
            date: LocalDate(2026, 10, 9),
          ),
        );
    await done;
  });

  group('wallets', () {
    Future<void> addFor(int wallet, int minor, int category, LocalDate date) => db
        .into(db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(
            amountMinor: minor,
            walletId: wallet,
            categoryId: Value(category),
            date: date,
          ),
        );

    setUp(() async {
      await addFor(son, 700, food, LocalDate(2026, 10, 2));
      await addFor(son, 40000, salary, LocalDate(2026, 10, 3));
    });

    test('a wallet has its own totals, categories and daily totals', () async {
      expect(
        first(await repository.watchTotals(october, walletId: son).first),
        const PeriodTotals(income: Money(40000), spent: Money(700)),
      );
      expect(
        first(await repository.watchTotals(october, walletId: me).first),
        const PeriodTotals(income: Money(520000), spent: Money(1800)),
      );
      expect(first(await repository.watchTotalsByCategory(october, TransactionKind.expense, walletId: son).first), {
        food: const Money(700),
      });
      expect(first(await repository.watchDailyTotals(october, walletId: son).first), {
        LocalDate(2026, 10, 2): const PeriodTotals(income: Money.zero, spent: Money(700)),
        LocalDate(2026, 10, 3): const PeriodTotals(income: Money(40000), spent: Money.zero),
      });
    });

    test('All wallets sums every wallet', () async {
      expect(
        first(await repository.watchTotals(october).first),
        const PeriodTotals(income: Money(560000), spent: Money(2500)),
      );
    });

    test('transfers are in no total, in any view', () async {
      await addTransferRows(db, from: me, to: son, amountMinor: 50000, date: LocalDate(2026, 10, 4));

      expect(
        first(await repository.watchTotals(october).first),
        const PeriodTotals(income: Money(560000), spent: Money(2500)),
      );
      expect(
        first(await repository.watchTotals(october, walletId: me).first),
        const PeriodTotals(income: Money(520000), spent: Money(1800)),
      );
      expect(
        first(await repository.watchTotals(october, walletId: son).first),
        const PeriodTotals(income: Money(40000), spent: Money(700)),
      );
      expect(first(await repository.watchTotalsByCategory(october, TransactionKind.expense).first), {
        food: const Money(2200),
        transport: const Money(300),
      });
      expect(first(await repository.watchDailyTotals(october).first).containsKey(LocalDate(2026, 10, 4)), isFalse);
    });

    test('totals by wallet carry income and spending per wallet', () async {
      await addTransferRows(db, from: me, to: son, amountMinor: 50000, date: LocalDate(2026, 10, 4));

      expect(first(await repository.watchTotalsByWallet(october).first), {
        me: const PeriodTotals(income: Money(520000), spent: Money(1800)),
        son: const PeriodTotals(income: Money(40000), spent: Money(700)),
      });
    });
  });
}
