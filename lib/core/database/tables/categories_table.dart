// Drift's documented CHECK-constraint pattern references the column getter
// inside its own definition, which this lint misreads as recursion.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

/// Default categories have a [seedKey] and get their name from the
/// translation files; custom categories have a user-typed [name]. Exactly one
/// of the two is set.
@TableIndex(name: 'idx_categories_kind', columns: {#kind})
class CategoriesTable extends Table {
  @override
  String get tableName => 'categories';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get seedKey => text().nullable().unique()();
  TextColumn get name => text().nullable().withLength(min: 1, max: 50)();

  /// `expense` or `income`: every transaction in the category is of this kind.
  /// It can't change while an expense or template references the category.
  TextColumn get kind => text().withDefault(const Constant('expense')).check(kind.isIn(const ['expense', 'income']))();

  /// Key into the curated icon registry, not a raw Material icon name.
  TextColumn get icon => text()();

  /// ARGB colour.
  IntColumn get color => integer()();
  IntColumn get sortOrder => integer()();
  BoolColumn get isHidden => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => ['CHECK ((seed_key IS NULL) <> (name IS NULL))'];
}
