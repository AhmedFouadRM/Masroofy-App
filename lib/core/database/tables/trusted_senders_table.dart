import 'package:drift/drift.dart';

/// The user's answer for an SMS sender: trusted, or not. It covers unknown
/// senders (asked once) and the on/off switch of the built-in ones.
class TrustedSendersTable extends Table {
  @override
  String get tableName => 'trusted_senders';

  TextColumn get sender => text()();
  BoolColumn get trusted => boolean()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {sender};
}
