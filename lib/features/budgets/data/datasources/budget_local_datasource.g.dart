// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$BudgetLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $BudgetsTableTable get budgetsTable => attachedDatabase.budgetsTable;
  $RecurringExpensesTableTable get recurringExpensesTable =>
      attachedDatabase.recurringExpensesTable;
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
  $$RecurringExpensesTableTableTableManager get recurringExpensesTable =>
      $$RecurringExpensesTableTableTableManager(
        _db.attachedDatabase,
        _db.recurringExpensesTable,
      );
  $$ExpensesTableTableTableManager get expensesTable =>
      $$ExpensesTableTableTableManager(_db.attachedDatabase, _db.expensesTable);
}
