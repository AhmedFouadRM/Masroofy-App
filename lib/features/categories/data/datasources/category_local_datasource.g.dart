// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$CategoryLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $WalletsTableTable get walletsTable => attachedDatabase.walletsTable;
  $RecurringExpensesTableTable get recurringExpensesTable =>
      attachedDatabase.recurringExpensesTable;
  $TransfersTableTable get transfersTable => attachedDatabase.transfersTable;
  $ExpensesTableTable get expensesTable => attachedDatabase.expensesTable;
  $BudgetsTableTable get budgetsTable => attachedDatabase.budgetsTable;
  CategoryLocalDatasourceManager get managers =>
      CategoryLocalDatasourceManager(this);
}

class CategoryLocalDatasourceManager {
  final _$CategoryLocalDatasourceMixin _db;
  CategoryLocalDatasourceManager(this._db);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.categoriesTable,
      );
  $$WalletsTableTableTableManager get walletsTable =>
      $$WalletsTableTableTableManager(_db.attachedDatabase, _db.walletsTable);
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
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db.attachedDatabase, _db.budgetsTable);
}
