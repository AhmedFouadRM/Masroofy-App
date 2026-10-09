import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';

part 'analytics_local_datasource.g.dart';

/// Income and spending in minor units, and the transfers in and out (both
/// positive). The by-category and daily queries never count transfers, so
/// theirs are 0.
typedef MinorTotals = ({int income, int spent, int transfersIn, int transfersOut});

/// Aggregate queries over expenses, in minor units, for one wallet or (with a
/// null `walletId`) all of them. The category's kind decides whether a row is
/// income or spending, and a transfer leg has none, so transfers are never
/// part of income or spending: the totals queries report them apart, and the
/// category and daily queries leave them out. Throws database errors; the
/// repository maps them to failures.
@DriftAccessor(tables: [ExpensesTable, CategoriesTable])
class AnalyticsLocalDatasource extends DatabaseAccessor<AppDatabase> with _$AnalyticsLocalDatasourceMixin {
  AnalyticsLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  Join<HasResultSet, dynamic> get _joinCategory =>
      innerJoin(categoriesTable, categoriesTable.id.equalsExp(expensesTable.categoryId));

  /// Keeps transfer legs (no category) in the result, for the transfer sums.
  Join<HasResultSet, dynamic> get _joinCategoryKeepingTransfers =>
      leftOuterJoin(categoriesTable, categoriesTable.id.equalsExp(expensesTable.categoryId));

  /// Dates are `YYYY-MM-DD` text, so string comparison is chronological and
  /// uses `idx_expenses_date`.
  Expression<bool> _inRange(DateRange range, int? walletId) {
    final inRange = expensesTable.date.isBetweenValues(_converter.toSql(range.start), _converter.toSql(range.end));
    return walletId == null ? inRange : inRange & expensesTable.walletId.equals(walletId);
  }

  /// `SUM(amount)` of the rows of [kind] (0 when there are none).
  Expression<int> _sumOf(TransactionKind kind) => CaseWhenExpression<int>(
    cases: [CaseWhen(categoriesTable.kind.equals(kind.name), then: expensesTable.amountMinor)],
    orElse: const Constant(0),
  ).sum();

  /// `SUM(amount)` of the transfer legs going [direction] (`in` or `out`).
  Expression<int> _sumOfTransfers(String direction) => CaseWhenExpression<int>(
    cases: [CaseWhen(expensesTable.direction.equals(direction), then: expensesTable.amountMinor)],
    orElse: const Constant(0),
  ).sum();

  Stream<MinorTotals> watchTotals(DateRange range, {int? walletId}) {
    final income = _sumOf(TransactionKind.income);
    final spent = _sumOf(TransactionKind.expense);
    final transfersIn = _sumOfTransfers('in');
    final transfersOut = _sumOfTransfers('out');
    final query = selectOnly(expensesTable).join([_joinCategoryKeepingTransfers])
      ..addColumns([income, spent, transfersIn, transfersOut])
      ..where(_inRange(range, walletId));
    return query.watchSingle().map(
      (row) => (
        income: row.read(income) ?? 0,
        spent: row.read(spent) ?? 0,
        transfersIn: row.read(transfersIn) ?? 0,
        transfersOut: row.read(transfersOut) ?? 0,
      ),
    );
  }

  Stream<Map<int, int>> watchTotalsByCategory(DateRange range, TransactionKind kind, {int? walletId}) {
    final sum = expensesTable.amountMinor.sum();
    final query = selectOnly(expensesTable).join([_joinCategory])
      ..addColumns([expensesTable.categoryId, sum])
      ..where(_inRange(range, walletId) & categoriesTable.kind.equals(kind.name))
      ..groupBy([expensesTable.categoryId]);
    return query.watch().map(
      (rows) => {for (final row in rows) row.read(expensesTable.categoryId)!: row.read(sum) ?? 0},
    );
  }

  /// Income, spending and transfers per wallet; wallets without any of them
  /// are absent.
  Stream<Map<int, MinorTotals>> watchTotalsByWallet(DateRange range) {
    final income = _sumOf(TransactionKind.income);
    final spent = _sumOf(TransactionKind.expense);
    final transfersIn = _sumOfTransfers('in');
    final transfersOut = _sumOfTransfers('out');
    final query = selectOnly(expensesTable).join([_joinCategoryKeepingTransfers])
      ..addColumns([expensesTable.walletId, income, spent, transfersIn, transfersOut])
      ..where(_inRange(range, null))
      ..groupBy([expensesTable.walletId]);
    return query.watch().map(
      (rows) => {
        for (final row in rows)
          row.read(expensesTable.walletId)!: (
            income: row.read(income) ?? 0,
            spent: row.read(spent) ?? 0,
            transfersIn: row.read(transfersIn) ?? 0,
            transfersOut: row.read(transfersOut) ?? 0,
          ),
      },
    );
  }

  Stream<Map<LocalDate, MinorTotals>> watchDailyTotals(DateRange range, {int? walletId}) {
    final income = _sumOf(TransactionKind.income);
    final spent = _sumOf(TransactionKind.expense);
    final query = selectOnly(expensesTable).join([_joinCategory])
      ..addColumns([expensesTable.date, income, spent])
      ..where(_inRange(range, walletId))
      ..groupBy([expensesTable.date]);
    return query.watch().map(
      (rows) => {
        for (final row in rows)
          _converter.fromSql(row.read(expensesTable.date)!): (
            income: row.read(income) ?? 0,
            spent: row.read(spent) ?? 0,
            transfersIn: 0,
            transfersOut: 0,
          ),
      },
    );
  }
}
