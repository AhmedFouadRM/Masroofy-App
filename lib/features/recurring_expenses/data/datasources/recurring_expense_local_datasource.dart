import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/database/tables/recurring_expenses_table.dart';
import 'package:masroofy/core/domain/local_date.dart';

part 'recurring_expense_local_datasource.g.dart';

/// Drift queries for recurring templates, and the generated expenses they
/// insert. Throws database errors; the repository maps them to failures.
@DriftAccessor(tables: [RecurringExpensesTable, ExpensesTable])
class RecurringExpenseLocalDatasource extends DatabaseAccessor<AppDatabase>
    with _$RecurringExpenseLocalDatasourceMixin {
  RecurringExpenseLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  Stream<List<RecurringExpensesTableData>> watchAll() =>
      (select(recurringExpensesTable)..orderBy([
            (r) => OrderingTerm.desc(r.isActive),
            (r) => OrderingTerm.asc(r.nextDueDate),
            (r) => OrderingTerm.asc(r.id),
          ]))
          .watch();

  Future<RecurringExpensesTableData?> getById(int id) =>
      (select(recurringExpensesTable)..where((r) => r.id.equals(id))).getSingleOrNull();

  /// Active templates whose next due date is on or before [today]
  /// (`idx_recurring_active_due`).
  Future<List<RecurringExpensesTableData>> getDue(LocalDate today) =>
      (select(recurringExpensesTable)..where(
            (r) => r.isActive.equals(true) & r.nextDueDate.isSmallerOrEqualValue(_converter.toSql(today)),
          ))
          .get();

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
