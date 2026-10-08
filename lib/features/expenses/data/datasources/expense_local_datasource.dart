import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';

part 'expense_local_datasource.g.dart';

/// Drift queries for expenses. Throws database errors; the repository maps
/// them to failures.
@DriftAccessor(tables: [ExpensesTable])
class ExpenseLocalDatasource extends DatabaseAccessor<AppDatabase> with _$ExpenseLocalDatasourceMixin {
  ExpenseLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  /// The WHERE clause for [filter]. Dates are `YYYY-MM-DD` text, so string
  /// comparison is chronological and uses `idx_expenses_date`.
  Expression<bool> _matches(ExpensesTable e, ExpenseFilter filter) {
    var condition = e.date.isBetweenValues(
      _converter.toSql(filter.range.start),
      _converter.toSql(filter.range.end),
    );
    if (filter.categoryId case final id?) condition &= e.categoryId.equals(id);
    if (filter.searchText case final text?) {
      // instr() is a plain substring test: no LIKE wildcards to escape.
      final needle = Variable<String>(text.toLowerCase());
      Expression<bool> found(Expression<String> column) =>
          FunctionCallExpression<int>('instr', [column.lower(), needle]).isBiggerThanValue(0);
      condition &= found(e.title) | found(e.note);
    }
    return condition;
  }

  Stream<List<ExpensesTableData>> watchExpenses(ExpenseFilter filter, {required int limit}) =>
      (select(expensesTable)
            ..where((e) => _matches(e, filter))
            ..orderBy([
              (e) => OrderingTerm.desc(e.date),
              (e) => OrderingTerm.desc(e.id),
            ])
            ..limit(limit))
          .watch();

  Stream<int> watchTotal(ExpenseFilter filter) {
    final sum = expensesTable.amountMinor.sum();
    final query = selectOnly(expensesTable)
      ..addColumns([sum])
      ..where(_matches(expensesTable, filter));
    return query.watchSingle().map((row) => row.read(sum) ?? 0);
  }

  Stream<Map<LocalDate, int>> watchDailyTotals(ExpenseFilter filter) {
    final sum = expensesTable.amountMinor.sum();
    final query = selectOnly(expensesTable)
      ..addColumns([expensesTable.date, sum])
      ..where(_matches(expensesTable, filter))
      ..groupBy([expensesTable.date]);
    return query.watch().map(
      (rows) => {for (final row in rows) _converter.fromSql(row.read(expensesTable.date)!): row.read(sum) ?? 0},
    );
  }

  Future<ExpensesTableData?> getById(int id) =>
      (select(expensesTable)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<int> insertExpense(ExpensesTableCompanion row) => into(expensesTable).insert(row);

  /// Returns the number of rows changed (0 when the id is gone).
  Future<int> updateExpense(int id, ExpensesTableCompanion row) =>
      (update(expensesTable)..where((e) => e.id.equals(id))).write(row);

  Future<int> deleteExpense(int id) => (delete(expensesTable)..where((e) => e.id.equals(id))).go();
}
