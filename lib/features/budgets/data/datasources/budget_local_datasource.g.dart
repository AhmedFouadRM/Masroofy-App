// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$BudgetLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $BudgetsTableTable get budgetsTable => attachedDatabase.budgetsTable;
  $WalletsTableTable get walletsTable => attachedDatabase.walletsTable;
  $RecurringExpensesTableTable get recurringExpensesTable =>
      attachedDatabase.recurringExpensesTable;
  $TransfersTableTable get transfersTable => attachedDatabase.transfersTable;
  $ExpensesTableTable get expensesTable => attachedDatabase.expensesTable;
  BudgetLocalDatasourceManager get managers =>
      BudgetLocalDatasourceManager(this);
}

class BudgetLocalDatasourceManager {
  final _$BudgetLocalDatasourceMixin _db;
  BudgetLocalDatasourceManager(this._db);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.categoriesTable,
      );
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db.attachedDatabase, _db.budgetsTable);
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
}
