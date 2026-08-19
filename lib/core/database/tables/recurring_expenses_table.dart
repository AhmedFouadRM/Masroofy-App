import 'package:drift/drift.dart';
import 'categories_table.dart';

class RecurringExpensesTable extends Table {
  @override
  String get tableName => 'recurring_expenses';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  RealColumn get amount => real()();
  IntColumn get categoryId => integer().references(CategoriesTable, #id)();
  TextColumn get frequency => text()();  // 'daily', 'weekly', 'monthly', 'yearly'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get nextDueDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
