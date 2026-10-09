// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$ExpenseLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $RecurringExpensesTableTable get recurringExpensesTable =>
      attachedDatabase.recurringExpensesTable;
  $ExpensesTableTable get expensesTable => attachedDatabase.expensesTable;
  ExpenseLocalDatasourceManager get managers =>
      ExpenseLocalDatasourceManager(this);
}

class ExpenseLocalDatasourceManager {
  final _$ExpenseLocalDatasourceMixin _db;
  ExpenseLocalDatasourceManager(this._db);
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
  $$ExpensesTableTableTableManager get expensesTable =>
      $$ExpensesTableTableTableManager(_db.attachedDatabase, _db.expensesTable);
}
