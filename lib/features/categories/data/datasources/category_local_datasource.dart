import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/tables/budgets_table.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/database/tables/recurring_expenses_table.dart';

part 'category_local_datasource.g.dart';

/// A category row with its usage, as read by [CategoryLocalDatasource.watchSummaries].
typedef CategorySummaryRow = ({
  CategoriesTableData category,
  int expenseCount,
  int recurringCount,
  int? budgetLimitMinor,
  String? budgetPeriod,
});

/// Drift queries for categories. Throws database errors; the repository maps
/// them to failures.
@DriftAccessor(tables: [CategoriesTable, ExpensesTable, RecurringExpensesTable, BudgetsTable])
class CategoryLocalDatasource extends DatabaseAccessor<AppDatabase> with _$CategoryLocalDatasourceMixin {
  CategoryLocalDatasource(super.attachedDatabase);

  /// Defaults first, then custom categories, each by `sort_order`.
  static const _orderBy = 'c.seed_key IS NULL, c.sort_order, c.id';

  Stream<List<CategoriesTableData>> watchAll({required bool includeHidden}) {
    final query = select(categoriesTable)
      ..orderBy([
        (c) => OrderingTerm(expression: c.seedKey.isNull()),
        (c) => OrderingTerm(expression: c.sortOrder),
        (c) => OrderingTerm(expression: c.id),
      ]);
    if (!includeHidden) query.where((c) => c.isHidden.equals(false));
    return query.watch();
  }

  Selectable<CategorySummaryRow> _summaries({int? id}) =>
      customSelect(
        '''
    SELECT c.*,
      (SELECT COUNT(*) FROM expenses e WHERE e.category_id = c.id) AS expense_count,
      (SELECT COUNT(*) FROM recurring_expenses r WHERE r.category_id = c.id) AS recurring_count,
      b.limit_minor AS budget_limit_minor,
      b.period AS budget_period
    FROM categories c
    LEFT JOIN budgets b ON b.category_id = c.id
    ${id == null ? '' : 'WHERE c.id = ?'}
    ORDER BY $_orderBy
    ''',
        variables: [if (id != null) Variable.withInt(id)],
        readsFrom: {categoriesTable, expensesTable, recurringExpensesTable, budgetsTable},
      ).map(
        (row) => (
          category: categoriesTable.map(row.data),
          expenseCount: row.read<int>('expense_count'),
          recurringCount: row.read<int>('recurring_count'),
          budgetLimitMinor: row.readNullable<int>('budget_limit_minor'),
          budgetPeriod: row.readNullable<String>('budget_period'),
        ),
      );

  Stream<List<CategorySummaryRow>> watchSummaries() => _summaries().watch();

  Future<CategorySummaryRow?> getSummary(int id) => _summaries(id: id).getSingleOrNull();

  Future<CategoriesTableData?> getById(int id) =>
      (select(categoriesTable)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<List<String>> customNames({int? excludeId}) async {
    final query = selectOnly(categoriesTable)
      ..addColumns([categoriesTable.name])
      ..where(categoriesTable.seedKey.isNull());
    if (excludeId != null) query.where(categoriesTable.id.equals(excludeId).not());
    final rows = await query.get();
    return [for (final row in rows) row.read(categoriesTable.name)!];
  }

  Future<int> insertCategory({required String name, required String icon, required int color}) => transaction(() async {
    final maxOrder = categoriesTable.sortOrder.max();
    final last = await (selectOnly(categoriesTable)..addColumns([maxOrder])).getSingle();
    return into(categoriesTable).insert(
      CategoriesTableCompanion.insert(
        name: Value(name),
        icon: icon,
        color: color,
        sortOrder: (last.read(maxOrder) ?? -1) + 1,
      ),
    );
  });

  /// Updates a custom category. Returns the number of rows changed.
  Future<int> updateCategory(int id, {required String name, required String icon, required int color}) =>
      (update(categoriesTable)..where((c) => c.id.equals(id) & c.seedKey.isNull())).write(
        CategoriesTableCompanion(
          name: Value(name),
          icon: Value(icon),
          color: Value(color),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );

  /// Moves expenses and templates to Other, then deletes the category (its
  /// budget cascades). Returns the number of categories deleted (0 or 1).
  Future<int> deleteCategory(int id) => transaction(() async {
    final other = await (select(
      categoriesTable,
    )..where((c) => c.seedKey.equals(DefaultCategories.otherSeedKey))).getSingle();
    final now = Value(DateTime.now().toUtc());
    await (update(expensesTable)..where((e) => e.categoryId.equals(id))).write(
      ExpensesTableCompanion(categoryId: Value(other.id), updatedAt: now),
    );
    await (update(recurringExpensesTable)..where((r) => r.categoryId.equals(id))).write(
      RecurringExpensesTableCompanion(categoryId: Value(other.id), updatedAt: now),
    );
    return (delete(categoriesTable)..where((c) => c.id.equals(id) & c.seedKey.isNull())).go();
  });
}
