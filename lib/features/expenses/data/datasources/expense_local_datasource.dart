import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';

part 'expense_local_datasource.g.dart';

/// An expense row with its category's kind (`expense` or `income`).
typedef ExpenseRow = ({ExpensesTableData expense, String kind});

/// Income and spending in minor units.
typedef MinorTotals = ({int income, int spent});

/// Drift queries for expenses. Throws database errors; the repository maps
/// them to failures. Every query joins the category, whose kind is the row's.
@DriftAccessor(tables: [ExpensesTable, CategoriesTable])
class ExpenseLocalDatasource extends DatabaseAccessor<AppDatabase> with _$ExpenseLocalDatasourceMixin {
  ExpenseLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  Join<HasResultSet, dynamic> get _joinCategory =>
      innerJoin(categoriesTable, categoriesTable.id.equalsExp(expensesTable.categoryId));

  /// The WHERE clause for [filter]. Dates are `YYYY-MM-DD` text, so string
  /// comparison is chronological and uses `idx_expenses_date`.
  Expression<bool> _matches(ExpenseFilter filter) {
    final e = expensesTable;
    var condition = e.date.isBetweenValues(
      _converter.toSql(filter.range.start),
      _converter.toSql(filter.range.end),
    );
    if (filter.kind case final kind?) condition &= categoriesTable.kind.equals(kind.name);
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

  Stream<List<ExpenseRow>> watchExpenses(ExpenseFilter filter, {required int limit}) =>
      (select(expensesTable).join([_joinCategory])
            ..where(_matches(filter))
            ..orderBy([
              OrderingTerm.desc(expensesTable.date),
              OrderingTerm.desc(expensesTable.id),
            ])
            ..limit(limit))
          .watch()
          .map(
            (rows) => [
              for (final row in rows) (expense: row.readTable(expensesTable), kind: row.read(categoriesTable.kind)!),
            ],
          );

  /// `SUM(amount)` of the rows of [kind] (null when there are none).
  Expression<int> _sumOf(TransactionKind kind) => CaseWhenExpression<int>(
    cases: [CaseWhen(categoriesTable.kind.equals(kind.name), then: expensesTable.amountMinor)],
    orElse: const Constant(0),
  ).sum();

  Stream<MinorTotals> watchTotals(ExpenseFilter filter) {
    final income = _sumOf(TransactionKind.income);
    final spent = _sumOf(TransactionKind.expense);
    final query = selectOnly(expensesTable).join([_joinCategory])
      ..addColumns([income, spent])
      ..where(_matches(filter));
    return query.watchSingle().map((row) => (income: row.read(income) ?? 0, spent: row.read(spent) ?? 0));
  }

  Stream<Map<LocalDate, MinorTotals>> watchDailyTotals(ExpenseFilter filter) {
    final income = _sumOf(TransactionKind.income);
    final spent = _sumOf(TransactionKind.expense);
    final query = selectOnly(expensesTable).join([_joinCategory])
      ..addColumns([expensesTable.date, income, spent])
      ..where(_matches(filter))
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

  Future<ExpenseRow?> getById(int id) async {
    final row = await (select(
      expensesTable,
    ).join([_joinCategory])..where(expensesTable.id.equals(id))).getSingleOrNull();
    return row == null ? null : (expense: row.readTable(expensesTable), kind: row.read(categoriesTable.kind)!);
  }

  /// The kind of category [id] (`expense` or `income`), or null when it is gone.
  Future<String?> categoryKind(int id) async =>
      (await (select(categoriesTable)..where((c) => c.id.equals(id))).getSingleOrNull())?.kind;

  Future<int> insertExpense(ExpensesTableCompanion row) => into(expensesTable).insert(row);

  /// Returns the number of rows changed (0 when the id is gone).
  Future<int> updateExpense(int id, ExpensesTableCompanion row) =>
      (update(expensesTable)..where((e) => e.id.equals(id))).write(row);

  Future<int> deleteExpense(int id) => (delete(expensesTable)..where((e) => e.id.equals(id))).go();
}
