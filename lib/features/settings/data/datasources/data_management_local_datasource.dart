import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/settings/data/backup_codec.dart';

/// An expense or transfer leg with its category (null for a transfer leg), for
/// the CSV export.
typedef ExpenseWithCategory = ({ExpensesTableData expense, CategoriesTableData? category});

/// Whole-database queries for export, backup, restore and clear. Settings is
/// the one feature that spans every table, so it reads them directly rather
/// than through the other features' repositories. Throws database errors; the
/// repository maps them to failures.
class DataManagementLocalDatasource {
  DataManagementLocalDatasource(this._database);

  final AppDatabase _database;

  /// Every expense and transfer leg with its category, oldest first. Dates are
  /// `YYYY-MM-DD` text, so ordering by them is chronological.
  Future<List<ExpenseWithCategory>> loadExpensesWithCategory() async {
    final query = _database.select(_database.expensesTable).join([
      leftOuterJoin(
        _database.categoriesTable,
        _database.categoriesTable.id.equalsExp(_database.expensesTable.categoryId),
      ),
    ])..orderBy([OrderingTerm.asc(_database.expensesTable.date), OrderingTerm.asc(_database.expensesTable.id)]);
    return [
      for (final row in await query.get())
        (expense: row.readTable(_database.expensesTable), category: row.readTableOrNull(_database.categoriesTable)),
    ];
  }

  Future<List<WalletsTableData>> loadWallets() =>
      (_database.select(_database.walletsTable)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();

  /// A consistent copy of every table (one transaction, so a concurrent
  /// write can't tear it).
  Future<BackupSnapshot> readSnapshot() => _database.transaction(
    () async => BackupSnapshot(
      wallets: await (_database.select(_database.walletsTable)..orderBy([(t) => OrderingTerm.asc(t.id)])).get(),
      categories: await (_database.select(_database.categoriesTable)..orderBy([(t) => OrderingTerm.asc(t.id)])).get(),
      recurring: await (_database.select(
        _database.recurringExpensesTable,
      )..orderBy([(t) => OrderingTerm.asc(t.id)])).get(),
      transfers: await (_database.select(_database.transfersTable)..orderBy([(t) => OrderingTerm.asc(t.id)])).get(),
      expenses: await (_database.select(_database.expensesTable)..orderBy([(t) => OrderingTerm.asc(t.id)])).get(),
      budgets: await (_database.select(_database.budgetsTable)..orderBy([(t) => OrderingTerm.asc(t.id)])).get(),
    ),
  );

  /// Replaces every row with [snapshot]'s, in one transaction: if anything
  /// throws, the old data is still there. Missing default categories are
  /// re-seeded afterwards.
  Future<void> replaceAll(BackupSnapshot snapshot) => _database.transaction(() async {
    await _deleteEverything();
    await _database.batch((batch) {
      // Parents first, so every foreign key resolves.
      batch
        ..insertAll(_database.walletsTable, snapshot.wallets)
        ..insertAll(_database.categoriesTable, snapshot.categories)
        ..insertAll(_database.recurringExpensesTable, snapshot.recurring)
        ..insertAll(_database.transfersTable, snapshot.transfers)
        ..insertAll(_database.expensesTable, snapshot.expenses)
        ..insertAll(_database.budgetsTable, snapshot.budgets);
    });
    await _database.seedDefaultCategories();
  });

  /// Deletes every row, then re-seeds the default categories and the wallet
  /// "Me", in one transaction. Returns the id of "Me".
  Future<int> clearAll() => _database.transaction(() async {
    await _deleteEverything();
    await _database.seedDefaultCategories();
    return _database.seedDefaultWallet();
  });

  /// Children before parents: expenses reference categories, wallets and
  /// transfers (RESTRICT), and templates reference wallets.
  Future<void> _deleteEverything() async {
    await _database.delete(_database.expensesTable).go();
    await _database.delete(_database.transfersTable).go();
    await _database.delete(_database.budgetsTable).go();
    await _database.delete(_database.recurringExpensesTable).go();
    await _database.delete(_database.categoriesTable).go();
    await _database.delete(_database.walletsTable).go();
  }
}
