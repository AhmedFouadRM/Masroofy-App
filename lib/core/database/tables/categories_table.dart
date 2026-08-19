import 'package:drift/drift.dart';

class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameEn => text().withLength(min: 1, max: 50)();
  TextColumn get nameAr => text().nullable()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
