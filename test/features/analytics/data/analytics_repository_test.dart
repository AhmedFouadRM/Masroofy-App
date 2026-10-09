import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:masroofy/features/analytics/data/repositories/analytics_repository_impl.dart';

void main() {
  late AppDatabase db;
  late AnalyticsRepositoryImpl repository;
  late int food;
  late int transport;
  final october = DateRange(LocalDate(2026, 10, 1), LocalDate(2026, 10, 31));

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repository = AnalyticsRepositoryImpl(AnalyticsLocalDatasource(db));
    Future<int> seed(String key) async =>
        (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals(key))).getSingle()).id;
    food = await seed('food');
    transport = await seed('transport');
    Future<void> add(int minor, int category, LocalDate date) => db
        .into(db.expensesTable)
        .insert(ExpensesTableCompanion.insert(amountMinor: minor, categoryId: category, date: date));
    await add(1000, food, LocalDate(2026, 10, 1));
    await add(500, food, LocalDate(2026, 10, 1));
    await add(300, transport, LocalDate(2026, 10, 5));
    await add(9999, food, LocalDate(2026, 9, 30)); // outside the range
  });
  tearDown(() => db.close());

  T first<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));

  test('totals a range', () async {
    expect(first(await repository.watchTotal(october).first), const Money(1800));
  });

  test('totals by category and by day', () async {
    expect(first(await repository.watchTotalsByCategory(october).first), {
      food: const Money(1500),
      transport: const Money(300),
    });
    expect(first(await repository.watchDailyTotals(october).first), {
      LocalDate(2026, 10, 1): const Money(1500),
      LocalDate(2026, 10, 5): const Money(300),
    });
  });

  test('re-emits when an expense is added', () async {
    final totals = repository.watchTotal(october).map(first);
    final done = expectLater(totals, emitsInOrder([const Money(1800), const Money(1900)]));
    await Future<void>.delayed(Duration.zero);
    await db
        .into(db.expensesTable)
        .insert(ExpensesTableCompanion.insert(amountMinor: 100, categoryId: food, date: LocalDate(2026, 10, 9)));
    await done;
  });
}
