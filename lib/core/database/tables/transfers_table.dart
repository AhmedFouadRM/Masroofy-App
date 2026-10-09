import 'package:drift/drift.dart';

/// Groups the two legs of a transfer. Each leg is an `expenses` row with its
/// `transfer_id` set: `direction = 'out'` in the source wallet, `'in'` in the
/// target. Deleting a transfer deletes both legs.
class TransfersTable extends Table {
  @override
  String get tableName => 'transfers';

  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
