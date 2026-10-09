import 'package:drift/drift.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';

/// The category the user last chose for a merchant. [merchantKey] is the
/// normalised merchant name. Deleting the category drops its mappings.
class MerchantCategoriesTable extends Table {
  @override
  String get tableName => 'merchant_categories';

  TextColumn get merchantKey => text()();
  IntColumn get categoryId => integer().references(CategoriesTable, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {merchantKey};
}
