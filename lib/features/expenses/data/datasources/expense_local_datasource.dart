import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/database/tables/transfers_table.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';

part 'expense_local_datasource.g.dart';

/// An `expenses` row with its category's kind (`expense` or `income`), or null
/// for a transfer leg, and the wallet of the transfer's other leg.
typedef ExpenseRow = ({ExpensesTableData expense, String? kind, int? counterpartWalletId});

/// Income and spending in minor units, and the net of transfers in minus out.
typedef MinorTotals = ({int income, int spent, int transfersNet});

/// Drift queries for expenses, income and the transfers listed beside them.
/// Throws database errors; the repository maps them to failures. Every query
/// joins the category, whose kind is the row's; a transfer leg has none, so it
/// is in neither income nor spending, only in `transfersNet`.
@DriftAccessor(tables: [ExpensesTable, CategoriesTable, TransfersTable])
class ExpenseLocalDatasource extends DatabaseAccessor<AppDatabase> with _$ExpenseLocalDatasourceMixin {
  ExpenseLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  late final $ExpensesTableTable _counterpart = alias(expensesTable, 'counterpart');

  Join<HasResultSet, dynamic> get _joinCategory =>
      leftOuterJoin(categoriesTable, categoriesTable.id.equalsExp(expensesTable.categoryId));

  /// The other leg of a transfer row (no match for other rows).
  Join<HasResultSet, dynamic> get _joinCounterpart => leftOuterJoin(
    _counterpart,
    _counterpart.transferId.equalsExp(expensesTable.transferId) & _counterpart.id.equalsExp(expensesTable.id).not(),
  );

  /// The WHERE clause for [filter]. Dates are `YYYY-MM-DD` text, so string
  /// comparison is chronological and uses `idx_expenses_date`.
  Expression<bool> _matches(ExpenseFilter filter) {
    final e = expensesTable;
    var condition = e.date.isBetweenValues(
      _converter.toSql(filter.range.start),
      _converter.toSql(filter.range.end),
    );
    if (filter.walletId case final id?) condition &= e.walletId.equals(id);
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

  ExpenseRow _toRow(TypedResult row) => (
    expense: row.readTable(expensesTable),
    kind: row.read(categoriesTable.kind),
    counterpartWalletId: row.read(_counterpart.walletId),
  );

  /// The newest [limit] rows. A transfer is listed once: by the wallet's own
  /// leg in a single wallet, by its out leg in All wallets.
  Stream<List<ExpenseRow>> watchExpenses(ExpenseFilter filter, {required int limit}) {
    var condition = _matches(filter);
    if (filter.walletId == null) {
      condition &= expensesTable.transferId.isNull() | expensesTable.direction.equals('out');
    }
    return (select(expensesTable).join([_joinCategory, _joinCounterpart])
          ..where(condition)
          ..orderBy([
            OrderingTerm.desc(expensesTable.date),
            OrderingTerm.desc(expensesTable.id),
          ])
          ..limit(limit))
        .watch()
        .map((rows) => rows.map(_toRow).toList());
  }

  /// `SUM(amount)` of the rows of [kind] (null when there are none).
  Expression<int> _sumOf(TransactionKind kind) => CaseWhenExpression<int>(
    cases: [CaseWhen(categoriesTable.kind.equals(kind.name), then: expensesTable.amountMinor)],
    orElse: const Constant(0),
  ).sum();

  /// Transfers in minus transfers out.
  Expression<int> get _sumOfTransfers => CaseWhenExpression<int>(
    cases: [
      CaseWhen(expensesTable.direction.equals('in'), then: expensesTable.amountMinor),
      CaseWhen(expensesTable.direction.equals('out'), then: expensesTable.amountMinor * const Constant<int>(-1)),
    ],
    orElse: const Constant(0),
  ).sum();

  Stream<MinorTotals> watchTotals(ExpenseFilter filter) {
    final income = _sumOf(TransactionKind.income);
    final spent = _sumOf(TransactionKind.expense);
    final transfers = _sumOfTransfers;
    final query = selectOnly(expensesTable).join([_joinCategory])
      ..addColumns([income, spent, transfers])
      ..where(_matches(filter));
    return query.watchSingle().map(
      (row) => (income: row.read(income) ?? 0, spent: row.read(spent) ?? 0, transfersNet: row.read(transfers) ?? 0),
    );
  }

  Stream<Map<LocalDate, MinorTotals>> watchDailyTotals(ExpenseFilter filter) {
    final income = _sumOf(TransactionKind.income);
    final spent = _sumOf(TransactionKind.expense);
    final transfers = _sumOfTransfers;
    final query = selectOnly(expensesTable).join([_joinCategory])
      ..addColumns([expensesTable.date, income, spent, transfers])
      ..where(_matches(filter))
      ..groupBy([expensesTable.date]);
    return query.watch().map(
      (rows) => {
        for (final row in rows)
          _converter.fromSql(row.read(expensesTable.date)!): (
            income: row.read(income) ?? 0,
            spent: row.read(spent) ?? 0,
            transfersNet: row.read(transfers) ?? 0,
          ),
      },
    );
  }

  Future<ExpenseRow?> getById(int id) async {
    final row = await (select(
      expensesTable,
    ).join([_joinCategory, _joinCounterpart])..where(expensesTable.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toRow(row);
  }

  /// The kind of category [id] (`expense` or `income`), or null when it is gone.
  Future<String?> categoryKind(int id) async =>
      (await (select(categoriesTable)..where((c) => c.id.equals(id))).getSingleOrNull())?.kind;

  Future<int> insertExpense(ExpensesTableCompanion row) => into(expensesTable).insert(row);

  /// Returns the number of rows changed (0 when the id is gone).
  Future<int> updateExpense(int id, ExpensesTableCompanion row) =>
      (update(expensesTable)..where((e) => e.id.equals(id))).write(row);

  /// Deletes the row; for a transfer leg, the whole transfer (both legs go
  /// with it). Returns the number of expenses or transfers deleted (0 or 1).
  Future<int> deleteExpense(int id) => transaction(() async {
    final row = await (select(expensesTable)..where((e) => e.id.equals(id))).getSingleOrNull();
    if (row == null) return 0;
    if (row.transferId case final transferId?) {
      return (delete(transfersTable)..where((t) => t.id.equals(transferId))).go();
    }
    return (delete(expensesTable)..where((e) => e.id.equals(id))).go();
  });
}
