import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';

part 'analytics_local_datasource.g.dart';

/// Income and spending in minor units.
typedef MinorTotals = ({int income, int spent});

/// Aggregate queries over expenses, in minor units. Every one joins the
/// category: its kind decides whether a row is income or spending. Throws
/// database errors; the repository maps them to failures.
@DriftAccessor(tables: [ExpensesTable, CategoriesTable])
class AnalyticsLocalDatasource extends DatabaseAccessor<AppDatabase> with _$AnalyticsLocalDatasourceMixin {
  AnalyticsLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  Join<HasResultSet, dynamic> get _joinCategory =>
      innerJoin(categoriesTable, categoriesTable.id.equalsExp(expensesTable.categoryId));

  /// Dates are `YYYY-MM-DD` text, so string comparison is chronological and
  /// uses `idx_expenses_date`.
  Expression<bool> _inRange(DateRange range) =>
      expensesTable.date.isBetweenValues(_converter.toSql(range.start), _converter.toSql(range.end));

  /// `SUM(amount)` of the rows of [kind] (0 when there are none).
  Expression<int> _sumOf(TransactionKind kind) => CaseWhenExpression<int>(
    cases: [CaseWhen(categoriesTable.kind.equals(kind.name), then: expensesTable.amountMinor)],
    orElse: const Constant(0),
  ).sum();

  Stream<MinorTotals> watchTotals(DateRange range) {
    final income = _sumOf(TransactionKind.income);
    final spent = _sumOf(TransactionKind.expense);
    final query = selectOnly(expensesTable).join([_joinCategory])
      ..addColumns([income, spent])
      ..where(_inRange(range));
    return query.watchSingle().map((row) => (income: row.read(income) ?? 0, spent: row.read(spent) ?? 0));
  }

  Stream<Map<int, int>> watchTotalsByCategory(DateRange range, TransactionKind kind) {
    final sum = expensesTable.amountMinor.sum();
    final query = selectOnly(expensesTable).join([_joinCategory])
      ..addColumns([expensesTable.categoryId, sum])
      ..where(_inRange(range) & categoriesTable.kind.equals(kind.name))
      ..groupBy([expensesTable.categoryId]);
    return query.watch().map(
      (rows) => {for (final row in rows) row.read(expensesTable.categoryId)!: row.read(sum) ?? 0},
    );
  }

  Stream<Map<LocalDate, MinorTotals>> watchDailyTotals(DateRange range) {
    final income = _sumOf(TransactionKind.income);
    final spent = _sumOf(TransactionKind.expense);
    final query = selectOnly(expensesTable).join([_joinCategory])
      ..addColumns([expensesTable.date, income, spent])
      ..where(_inRange(range))
      ..groupBy([expensesTable.date]);
    return query.watch().map(
      (rows) => {
        for (final row in rows)
          _converter.fromSql(row.read(expensesTable.date)!): (
            income: row.read(income) ?? 0,
            spent: row.read(spent) ?? 0,
          ),
      },
    );
  }
}
