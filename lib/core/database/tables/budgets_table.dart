// Drift's documented CHECK-constraint pattern references the column getter
// inside its own definition, which this lint misreads as recursion.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';

class BudgetsTable extends Table {
  @override
  String get tableName => 'budgets';

  IntColumn get id => integer().autoIncrement()();

  /// One budget per category; deleted together with its category.
  IntColumn get categoryId =>
      integer().unique().references(CategoriesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get limitMinor => integer().check(limitMinor.isBiggerThanValue(0))();
  TextColumn get period => text().check(period.isIn(const ['weekly', 'monthly']))();

  /// Start of the period whose one-shot "exceeded" alert was already shown.
  TextColumn get lastAlertedPeriodStart => text().map(const LocalDateConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
