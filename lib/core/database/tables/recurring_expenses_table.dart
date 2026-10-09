// Drift's documented CHECK-constraint pattern references the column getter
// inside its own definition, which this lint misreads as recursion.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/wallets_table.dart';

@TableIndex(name: 'idx_recurring_active_due', columns: {#isActive, #nextDueDate})
class RecurringExpensesTable extends Table {
  @override
  String get tableName => 'recurring_expenses';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  IntColumn get amountMinor => integer().check(amountMinor.isBiggerThanValue(0))();

  /// The wallet its generated rows go to.
  IntColumn get walletId => integer().references(WalletsTable, #id, onDelete: KeyAction.restrict)();

  /// The app reassigns templates to "Other" before deleting a category.
  IntColumn get categoryId => integer().references(CategoriesTable, #id, onDelete: KeyAction.restrict)();
  TextColumn get frequency => text().check(frequency.isIn(const ['daily', 'weekly', 'monthly', 'yearly']))();

  /// Anchor for occurrence calculation (occurrence n = startDate + n periods).
  TextColumn get startDate => text().map(const LocalDateConverter())();
  TextColumn get nextDueDate => text().map(const LocalDateConverter())();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
