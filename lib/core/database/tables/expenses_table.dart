// Drift's documented CHECK-constraint pattern references the column getter
// inside its own definition, which this lint misreads as recursion.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/recurring_expenses_table.dart';

@TableIndex(name: 'idx_expenses_date', columns: {#date})
@TableIndex(name: 'idx_expenses_category_date', columns: {#categoryId, #date})
class ExpensesTable extends Table {
  @override
  String get tableName => 'expenses';

  IntColumn get id => integer().autoIncrement()();

  /// Optional: when null, the UI shows the category's display name.
  TextColumn get title => text().nullable().withLength(min: 1, max: 100)();
  IntColumn get amountMinor => integer().check(amountMinor.isBiggerThanValue(0))();

  /// The app reassigns expenses to "Other" before deleting a category.
  IntColumn get categoryId =>
      integer().references(CategoriesTable, #id, onDelete: KeyAction.restrict)();
  TextColumn get date => text().map(const LocalDateConverter())();
  TextColumn get note => text().nullable().withLength(max: 500)();
  IntColumn get recurringExpenseId => integer()
      .nullable()
      .references(RecurringExpensesTable, #id, onDelete: KeyAction.setNull)();

  /// The template due date this row was generated for; kept after the
  /// template is deleted so the recurring badge survives.
  TextColumn get occurrenceDate => text().map(const LocalDateConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// A template can never generate twice for the same due date. Rows with a
  /// NULL template id (manual entries) never conflict.
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
        {recurringExpenseId, occurrenceDate},
      ];
}
