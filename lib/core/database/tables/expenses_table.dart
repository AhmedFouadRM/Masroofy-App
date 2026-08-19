import 'package:drift/drift.dart';
import 'categories_table.dart';
import 'recurring_expenses_table.dart';

class ExpensesTable extends Table {
  @override
  String get tableName => 'expenses';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real()();
  IntColumn get categoryId => integer().references(CategoriesTable, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  IntColumn get recurringExpenseId => integer().nullable().references(RecurringExpensesTable, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
