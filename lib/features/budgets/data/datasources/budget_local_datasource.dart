import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/budgets_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';

part 'budget_local_datasource.g.dart';

/// A budget row with its spend in its current window, in minor units.
typedef BudgetSpendRow = ({BudgetsTableData budget, int spent});

/// Drift queries for budgets. Throws database errors; the repository maps
/// them to failures.
@DriftAccessor(tables: [BudgetsTable, ExpensesTable])
class BudgetLocalDatasource extends DatabaseAccessor<AppDatabase> with _$BudgetLocalDatasourceMixin {
  BudgetLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  /// Every budget with the sum of its category's expenses in [week] or
  /// [month], whichever its period uses. Dates are `YYYY-MM-DD` text, so
  /// BETWEEN is chronological and uses `idx_expenses_category_date`.
  Stream<List<BudgetSpendRow>> watchWithSpend({required DateRange week, required DateRange month}) =>
      customSelect(
        '''
        SELECT b.*, (
          SELECT COALESCE(SUM(e.amount_minor), 0) FROM expenses e
          WHERE e.category_id = b.category_id
            AND e.date BETWEEN
              CASE b.period WHEN 'weekly' THEN ?1 ELSE ?3 END
              AND CASE b.period WHEN 'weekly' THEN ?2 ELSE ?4 END
        ) AS spent
        FROM budgets b
        ORDER BY b.id
        ''',
        variables: [
          Variable(_converter.toSql(week.start)),
          Variable(_converter.toSql(week.end)),
          Variable(_converter.toSql(month.start)),
          Variable(_converter.toSql(month.end)),
        ],
        readsFrom: {budgetsTable, expensesTable},
      ).watch().map(
        (rows) => [
          for (final row in rows) (budget: budgetsTable.map(row.data), spent: row.read<int>('spent')),
        ],
      );

  Future<BudgetsTableData?> getById(int id) => (select(budgetsTable)..where((b) => b.id.equals(id))).getSingleOrNull();

  Future<int> insertBudget(BudgetsTableCompanion row) => into(budgetsTable).insert(row);

  /// Returns the number of rows changed (0 when the id is gone).
  Future<int> updateBudget(int id, BudgetsTableCompanion row) =>
      (update(budgetsTable)..where((b) => b.id.equals(id))).write(row);

  Future<int> deleteBudget(int id) => (delete(budgetsTable)..where((b) => b.id.equals(id))).go();

  Future<int> markAlerted(int id, LocalDate periodStart) => updateBudget(
    id,
    BudgetsTableCompanion(lastAlertedPeriodStart: Value(periodStart)),
  );
}
