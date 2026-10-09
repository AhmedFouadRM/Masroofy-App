import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/database/tables/recurring_expenses_table.dart';
import 'package:masroofy/core/database/tables/transfers_table.dart';
import 'package:masroofy/core/database/tables/wallets_table.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';

part 'wallet_local_datasource.g.dart';

/// A wallet row with its balance over a range and its usage, as read by
/// [WalletLocalDatasource.watchSummaries].
typedef WalletSummaryRow = ({
  WalletsTableData wallet,
  int balanceMinor,
  int expenseCount,
  int transferCount,
  int recurringCount,
});

/// What [WalletLocalDatasource.deleteWallet] did.
enum WalletDeletion { deleted, notFound, lastWallet, needsMoveTarget }

/// Drift queries for wallets and transfers. Throws database errors; the
/// repositories map them to failures.
@DriftAccessor(tables: [WalletsTable, ExpensesTable, RecurringExpensesTable, TransfersTable, CategoriesTable])
class WalletLocalDatasource extends DatabaseAccessor<AppDatabase> with _$WalletLocalDatasourceMixin {
  WalletLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  /// Every wallet by `sort_order`, with its balance over [range]: income and
  /// transfers in, minus spending and transfers out. Dates are `YYYY-MM-DD`
  /// text, so BETWEEN is chronological and uses `idx_expenses_wallet_date`.
  Stream<List<WalletSummaryRow>> watchSummaries(DateRange range) =>
      customSelect(
        '''
        SELECT w.*, (
          SELECT COALESCE(SUM(
            CASE
              WHEN e.transfer_id IS NOT NULL THEN CASE e.direction WHEN 'in' THEN e.amount_minor ELSE -e.amount_minor END
              WHEN c.kind = 'income' THEN e.amount_minor
              ELSE -e.amount_minor
            END
          ), 0)
          FROM expenses e LEFT JOIN categories c ON c.id = e.category_id
          WHERE e.wallet_id = w.id AND e.date BETWEEN ?1 AND ?2
        ) AS balance_minor,
        (SELECT COUNT(*) FROM expenses e WHERE e.wallet_id = w.id) AS expense_count,
        (SELECT COUNT(*) FROM expenses e WHERE e.wallet_id = w.id AND e.transfer_id IS NOT NULL) AS transfer_count,
        (SELECT COUNT(*) FROM recurring_expenses r WHERE r.wallet_id = w.id) AS recurring_count
        FROM wallets w
        ORDER BY w.sort_order, w.id
        ''',
        variables: [Variable(_converter.toSql(range.start)), Variable(_converter.toSql(range.end))],
        readsFrom: {walletsTable, expensesTable, recurringExpensesTable, categoriesTable},
      ).watch().map(
        (rows) => [
          for (final row in rows)
            (
              wallet: walletsTable.map(row.data),
              balanceMinor: row.read<int>('balance_minor'),
              expenseCount: row.read<int>('expense_count'),
              transferCount: row.read<int>('transfer_count'),
              recurringCount: row.read<int>('recurring_count'),
            ),
        ],
      );

  Future<WalletsTableData?> getById(int id) => (select(walletsTable)..where((w) => w.id.equals(id))).getSingleOrNull();

  Future<List<String>> customNames({int? excludeId}) async {
    final query = selectOnly(walletsTable)
      ..addColumns([walletsTable.name])
      ..where(walletsTable.seedKey.isNull());
    if (excludeId != null) query.where(walletsTable.id.equals(excludeId).not());
    final rows = await query.get();
    return [for (final row in rows) row.read(walletsTable.name)!];
  }

  Future<int> insertWallet({required String name, required String icon, required int color}) => transaction(() async {
    final maxOrder = walletsTable.sortOrder.max();
    final last = await (selectOnly(walletsTable)..addColumns([maxOrder])).getSingle();
    return into(walletsTable).insert(
      WalletsTableCompanion.insert(
        name: Value(name),
        icon: icon,
        color: color,
        sortOrder: (last.read(maxOrder) ?? -1) + 1,
      ),
    );
  });

  /// Updates a wallet. A null [name] keeps a seeded wallet's name; a name
  /// replaces the seed key. Returns the number of rows changed.
  Future<int> updateWallet(int id, {required String? name, required String icon, required int color}) =>
      (update(walletsTable)..where((w) => w.id.equals(id))).write(
        WalletsTableCompanion(
          name: name == null ? const Value.absent() : Value(name),
          seedKey: name == null ? const Value.absent() : const Value(null),
          icon: Value(icon),
          color: Value(color),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );

  /// In one transaction: turns the transfers that touch the wallet into
  /// ordinary rows (Other for the out leg, Other income for the in leg), moves
  /// the wallet's rows and templates to [moveTo], and deletes the wallet.
  Future<WalletDeletion> deleteWallet(int id, {int? moveTo}) => transaction(() async {
    final wallet = await getById(id);
    if (wallet == null) return WalletDeletion.notFound;
    final count = await (selectOnly(walletsTable)..addColumns([walletsTable.id.count()])).getSingle();
    if (count.read(walletsTable.id.count())! <= 1) return WalletDeletion.lastWallet;

    final rows =
        await (selectOnly(expensesTable)
              ..addColumns([expensesTable.id.count()])
              ..where(expensesTable.walletId.equals(id)))
            .getSingle();
    final templates =
        await (selectOnly(recurringExpensesTable)
              ..addColumns([recurringExpensesTable.id.count()])
              ..where(recurringExpensesTable.walletId.equals(id)))
            .getSingle();
    final inUse = rows.read(expensesTable.id.count())! > 0 || templates.read(recurringExpensesTable.id.count())! > 0;
    if (inUse && moveTo == null) return WalletDeletion.needsMoveTarget;

    await _dissolveTransfers(id);
    if (moveTo != null) {
      final now = Value(DateTime.now().toUtc());
      await (update(expensesTable)..where((e) => e.walletId.equals(id))).write(
        ExpensesTableCompanion(walletId: Value(moveTo), updatedAt: now),
      );
      await (update(recurringExpensesTable)..where((r) => r.walletId.equals(id))).write(
        RecurringExpensesTableCompanion(walletId: Value(moveTo), updatedAt: now),
      );
    }
    await (delete(walletsTable)..where((w) => w.id.equals(id))).go();
    return WalletDeletion.deleted;
  });

  /// Every transfer with a leg in wallet [id] becomes two ordinary rows: an
  /// expense in Other for the out leg, income in Other income for the in leg.
  Future<void> _dissolveTransfers(int id) async {
    final other = await (select(
      categoriesTable,
    )..where((c) => c.seedKey.equals(DefaultCategories.otherSeedKey))).getSingle();
    final otherIncome = await (select(
      categoriesTable,
    )..where((c) => c.seedKey.equals(DefaultCategories.otherIncomeSeedKey))).getSingle();
    final legs =
        await (selectOnly(expensesTable)
              ..addColumns([expensesTable.transferId])
              ..where(expensesTable.walletId.equals(id) & expensesTable.transferId.isNotNull()))
            .get();
    final transferIds = [for (final leg in legs) leg.read(expensesTable.transferId)!];
    if (transferIds.isEmpty) return;
    final now = Value(DateTime.now().toUtc());
    for (final (direction, category) in [('out', other.id), ('in', otherIncome.id)]) {
      await (update(expensesTable)..where((e) => e.transferId.isIn(transferIds) & e.direction.equals(direction))).write(
        ExpensesTableCompanion(
          categoryId: Value(category),
          transferId: const Value(null),
          direction: const Value(null),
          updatedAt: now,
        ),
      );
    }
    await (delete(transfersTable)..where((t) => t.id.isIn(transferIds))).go();
  }

  /// Inserts the transfer and its two legs. Returns the transfer id.
  Future<int> insertTransfer({
    required int fromWalletId,
    required int toWalletId,
    required int amountMinor,
    required LocalDate date,
    required String? note,
  }) => transaction(() async {
    final id = await into(transfersTable).insert(TransfersTableCompanion.insert());
    for (final (walletId, direction) in [(fromWalletId, 'out'), (toWalletId, 'in')]) {
      await into(expensesTable).insert(
        ExpensesTableCompanion.insert(
          walletId: walletId,
          amountMinor: amountMinor,
          date: date,
          note: Value(note),
          transferId: Value(id),
          direction: Value(direction),
        ),
      );
    }
    return id;
  });

  /// Updates both legs and the transfer. Returns the number of legs changed
  /// (2, or 0 when the transfer is gone).
  Future<int> updateTransfer(
    int id, {
    required int fromWalletId,
    required int toWalletId,
    required int amountMinor,
    required LocalDate date,
    required String? note,
  }) => transaction(() async {
    final now = Value(DateTime.now().toUtc());
    var changed = 0;
    for (final (walletId, direction) in [(fromWalletId, 'out'), (toWalletId, 'in')]) {
      changed += await (update(expensesTable)..where((e) => e.transferId.equals(id) & e.direction.equals(direction)))
          .write(
            ExpensesTableCompanion(
              walletId: Value(walletId),
              amountMinor: Value(amountMinor),
              date: Value(date),
              note: Value(note),
              updatedAt: now,
            ),
          );
    }
    if (changed > 0) {
      await (update(transfersTable)..where((t) => t.id.equals(id))).write(TransfersTableCompanion(updatedAt: now));
    }
    return changed;
  });
}
