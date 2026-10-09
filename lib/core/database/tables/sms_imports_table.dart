// Drift's documented CHECK-constraint pattern references the column getter
// inside its own definition, which this lint misreads as recursion.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';

/// One bank SMS that SMS Import turned into a transaction, or is waiting to.
/// **The SMS body is never stored**: only the parsed fields and [smsKey], a
/// hash of sender + SMS timestamp + body, which makes an import idempotent.
@TableIndex(name: 'idx_sms_imports_received_at', columns: {#receivedAt})
@TableIndex(name: 'idx_sms_imports_expense', columns: {#expenseId})
class SmsImportsTable extends Table {
  @override
  String get tableName => 'sms_imports';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get smsKey => text().unique()();
  TextColumn get sender => text()();
  DateTimeColumn get receivedAt => dateTime()();

  /// `expense` or `income`.
  TextColumn get kind => text().check(kind.isIn(const ['expense', 'income']))();
  IntColumn get amountMinor => integer().check(amountMinor.isBiggerThanValue(0))();

  /// ISO 4217 code as written in the message (`EGP`).
  TextColumn get currency => text()();
  TextColumn get merchant => text().nullable()();

  /// Resolved when the SMS arrived; cleared if the category is deleted.
  IntColumn get categoryId => integer().nullable().references(CategoriesTable, #id, onDelete: KeyAction.setNull)();
  TextColumn get cardLast4 => text().nullable()();
  TextColumn get date => text().map(const LocalDateConverter())();
  TextColumn get note => text().nullable()();

  /// `added`, `pending` (waiting for the user), `ignored` or `cancelled`.
  TextColumn get status => text().check(status.isIn(const ['added', 'pending', 'ignored', 'cancelled']))();

  /// The transaction this import became; cleared when that row is deleted.
  IntColumn get expenseId => integer().nullable().references(ExpensesTable, #id, onDelete: KeyAction.setNull)();
}
