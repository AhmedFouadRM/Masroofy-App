import 'package:drift/drift.dart';
import 'categories_table.dart';

class BudgetsTable extends Table {
  @override
  String get tableName => 'budgets';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().unique().references(CategoriesTable, #id)();
  RealColumn get limitAmount => real()();
  TextColumn get period => text()();  // 'weekly' or 'monthly'
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
