import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/local_date.dart';

/// Adds a custom wallet after the existing ones. Returns its id.
Future<int> addWallet(AppDatabase db, String name, {String icon = 'person', int color = 0xFF000000}) async {
  final last = await (db.selectOnly(db.walletsTable)..addColumns([db.walletsTable.sortOrder.max()])).getSingle();
  return db
      .into(db.walletsTable)
      .insert(
        WalletsTableCompanion.insert(
          name: Value(name),
          icon: icon,
          color: color,
          sortOrder: (last.read(db.walletsTable.sortOrder.max()) ?? -1) + 1,
        ),
      );
}

/// Inserts a transfer as its two legs, as the app stores it. Returns the
/// transfer id.
Future<int> addTransferRows(
  AppDatabase db, {
  required int from,
  required int to,
  required int amountMinor,
  required LocalDate date,
  String? note,
}) async {
  final id = await db.into(db.transfersTable).insert(TransfersTableCompanion.insert());
  for (final (walletId, direction) in [(from, 'out'), (to, 'in')]) {
    await db
        .into(db.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(
            amountMinor: amountMinor,
            walletId: walletId,
            date: date,
            note: Value(note),
            transferId: Value(id),
            direction: Value(direction),
          ),
        );
  }
  return id;
}
