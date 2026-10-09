// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$AnalyticsLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $WalletsTableTable get walletsTable => attachedDatabase.walletsTable;
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $RecurringExpensesTableTable get recurringExpensesTable =>
      attachedDatabase.recurringExpensesTable;
  $TransfersTableTable get transfersTable => attachedDatabase.transfersTable;
  $ExpensesTableTable get expensesTable => attachedDatabase.expensesTable;
  AnalyticsLocalDatasourceManager get managers =>
      AnalyticsLocalDatasourceManager(this);
}

class AnalyticsLocalDatasourceManager {
  final _$AnalyticsLocalDatasourceMixin _db;
  AnalyticsLocalDatasourceManager(this._db);
  $$WalletsTableTableTableManager get walletsTable =>
      $$WalletsTableTableTableManager(_db.attachedDatabase, _db.walletsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.categoriesTable,
      );
  $$RecurringExpensesTableTableTableManager get recurringExpensesTable =>
      $$RecurringExpensesTableTableTableManager(
        _db.attachedDatabase,
        _db.recurringExpensesTable,
      );
  $$TransfersTableTableTableManager get transfersTable =>
      $$TransfersTableTableTableManager(
        _db.attachedDatabase,
        _db.transfersTable,
      );
  $$ExpensesTableTableTableManager get expensesTable =>
      $$ExpensesTableTableTableManager(_db.attachedDatabase, _db.expensesTable);
}
