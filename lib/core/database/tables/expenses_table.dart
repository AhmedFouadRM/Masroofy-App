// Drift's documented CHECK-constraint pattern references the column getter
// inside its own definition, which this lint misreads as recursion.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/recurring_expenses_table.dart';
import 'package:masroofy/core/database/tables/transfers_table.dart';
import 'package:masroofy/core/database/tables/wallets_table.dart';

@TableIndex(name: 'idx_expenses_date', columns: {#date})
@TableIndex(name: 'idx_expenses_category_date', columns: {#categoryId, #date})
@TableIndex(name: 'idx_expenses_wallet_date', columns: {#walletId, #date})
class ExpensesTable extends Table {
  @override
  String get tableName => 'expenses';

  IntColumn get id => integer().autoIncrement()();

  /// Optional: when null, the UI shows the category's display name.
  TextColumn get title => text().nullable().withLength(min: 1, max: 100)();
  IntColumn get amountMinor => integer().check(amountMinor.isBiggerThanValue(0))();

  /// The wallet the row belongs to. A transfer leg belongs to its own wallet.
  IntColumn get walletId => integer().references(WalletsTable, #id, onDelete: KeyAction.restrict)();

  /// The app reassigns expenses to "Other" before deleting a category. Null
  /// only for transfer legs.
  IntColumn get categoryId => integer().nullable().references(CategoriesTable, #id, onDelete: KeyAction.restrict)();
  TextColumn get date => text().map(const LocalDateConverter())();
  TextColumn get note => text().nullable().withLength(max: 500)();
  IntColumn get recurringExpenseId =>
      integer().nullable().references(RecurringExpensesTable, #id, onDelete: KeyAction.setNull)();

  /// The template due date this row was generated for; kept after the
  /// template is deleted so the recurring badge survives.
  TextColumn get occurrenceDate => text().map(const LocalDateConverter()).nullable()();

  /// Set on the two legs of a transfer; deleting the transfer deletes both.
  IntColumn get transferId => integer().nullable().references(TransfersTable, #id, onDelete: KeyAction.cascade)();

  /// `out` (the source wallet's leg) or `in` (the target's); set only on
  /// transfer legs.
  TextColumn get direction => text().nullable().check(direction.isIn(const ['out', 'in']))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// A template can never generate twice for the same due date. Rows with a
  /// NULL template id (manual entries) never conflict.
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {recurringExpenseId, occurrenceDate},
  ];

  /// A category on every row except transfer legs, and a direction on
  /// transfer legs only.
  @override
  List<String> get customConstraints => [
    'CHECK ((transfer_id IS NULL) = (category_id IS NOT NULL))',
    'CHECK ((transfer_id IS NULL) = (direction IS NULL))',
  ];
}
