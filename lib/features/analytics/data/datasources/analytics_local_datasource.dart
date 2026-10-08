import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';

part 'analytics_local_datasource.g.dart';

/// Aggregate queries over expenses, in minor units. Throws database errors;
/// the repository maps them to failures.
@DriftAccessor(tables: [ExpensesTable])
class AnalyticsLocalDatasource extends DatabaseAccessor<AppDatabase> with _$AnalyticsLocalDatasourceMixin {
  AnalyticsLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  /// Dates are `YYYY-MM-DD` text, so string comparison is chronological and
  /// uses `idx_expenses_date`.
  Expression<bool> _inRange(DateRange range) =>
      expensesTable.date.isBetweenValues(_converter.toSql(range.start), _converter.toSql(range.end));

  Stream<int> watchTotal(DateRange range) {
    final sum = expensesTable.amountMinor.sum();
    final query = selectOnly(expensesTable)
      ..addColumns([sum])
      ..where(_inRange(range));
    return query.watchSingle().map((row) => row.read(sum) ?? 0);
  }

  Stream<Map<int, int>> watchTotalsByCategory(DateRange range) {
    final sum = expensesTable.amountMinor.sum();
    final query = selectOnly(expensesTable)
      ..addColumns([expensesTable.categoryId, sum])
      ..where(_inRange(range))
      ..groupBy([expensesTable.categoryId]);
    return query.watch().map(
      (rows) => {for (final row in rows) row.read(expensesTable.categoryId)!: row.read(sum) ?? 0},
    );
  }

  Stream<Map<LocalDate, int>> watchDailyTotals(DateRange range) {
    final sum = expensesTable.amountMinor.sum();
    final query = selectOnly(expensesTable)
      ..addColumns([expensesTable.date, sum])
      ..where(_inRange(range))
      ..groupBy([expensesTable.date]);
    return query.watch().map(
      (rows) => {for (final row in rows) _converter.fromSql(row.read(expensesTable.date)!): row.read(sum) ?? 0},
    );
  }
}
