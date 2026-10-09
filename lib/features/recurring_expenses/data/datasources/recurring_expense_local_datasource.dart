import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/database/tables/recurring_expenses_table.dart';
import 'package:masroofy/core/domain/local_date.dart';

part 'recurring_expense_local_datasource.g.dart';

/// A template with its category's kind (`expense` or `income`).
typedef TemplateRow = ({RecurringExpensesTableData template, String kind});

/// Drift queries for recurring templates, and the generated expenses they
/// insert. Throws database errors; the repository maps them to failures.
@DriftAccessor(tables: [RecurringExpensesTable, ExpensesTable, CategoriesTable])
class RecurringExpenseLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$RecurringExpenseLocalDatasourceMixin {
  RecurringExpenseLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  JoinedSelectStatement<HasResultSet, dynamic> _withKind() => select(recurringExpensesTable).join([
    innerJoin(categoriesTable, categoriesTable.id.equalsExp(recurringExpensesTable.categoryId)),
  ]);

  TemplateRow _toRow(TypedResult row) =>
      (template: row.readTable(recurringExpensesTable), kind: row.read(categoriesTable.kind)!);

  Stream<List<TemplateRow>> watchAll() =>
      (_withKind()..orderBy([
            OrderingTerm.desc(recurringExpensesTable.isActive),
            OrderingTerm.asc(recurringExpensesTable.nextDueDate),
            OrderingTerm.asc(recurringExpensesTable.id),
          ]))
          .watch()
          .map((rows) => rows.map(_toRow).toList());

  Future<TemplateRow?> getById(int id) async {
    final row = await (_withKind()..where(recurringExpensesTable.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toRow(row);
  }

  /// The kind of category [id] (`expense` or `income`), or null when it is gone.
  Future<String?> categoryKind(int id) async =>
      (await (select(categoriesTable)..where((c) => c.id.equals(id))).getSingleOrNull())?.kind;

  /// Active templates whose next due date is on or before [today]
  /// (`idx_recurring_active_due`).
  Future<List<TemplateRow>> getDue(LocalDate today) async =>
      (await (_withKind()..where(
                recurringExpensesTable.isActive.equals(true) &
                    recurringExpensesTable.nextDueDate.isSmallerOrEqualValue(_converter.toSql(today)),
              ))
              .get())
          .map(_toRow)
          .toList();

  Future<LocalDate?> lastOccurrence(int id) async {
    final latest = expensesTable.occurrenceDate.max();
    final query = selectOnly(expensesTable)
      ..addColumns([latest])
      ..where(expensesTable.recurringExpenseId.equals(id));
    final iso = (await query.getSingle()).read(latest);
    return iso == null ? null : _converter.fromSql(iso);
  }

  Future<int> insertTemplate(RecurringExpensesTableCompanion row) => into(recurringExpensesTable).insert(row);

  /// Returns the number of rows changed (0 when the id is gone).
  Future<int> updateTemplate(int id, RecurringExpensesTableCompanion row) =>
      (update(recurringExpensesTable)..where((r) => r.id.equals(id))).write(row);

  Future<int> deleteTemplate(int id) => (delete(recurringExpensesTable)..where((r) => r.id.equals(id))).go();

  /// Inserts a generated expense unless the template already has one for
  /// that occurrence (unique `(recurring_expense_id, occurrence_date)`).
  /// Returns whether a row was added.
  Future<bool> insertOccurrence(ExpensesTableCompanion row) async =>
      await into(expensesTable).insertReturningOrNull(row, mode: InsertMode.insertOrIgnore) != null;
}
