// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$AnalyticsLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $RecurringExpensesTableTable get recurringExpensesTable =>
      attachedDatabase.recurringExpensesTable;
  $ExpensesTableTable get expensesTable => attachedDatabase.expensesTable;
  AnalyticsLocalDatasourceManager get managers =>
      AnalyticsLocalDatasourceManager(this);
}

class AnalyticsLocalDatasourceManager {
  final _$AnalyticsLocalDatasourceMixin _db;
  AnalyticsLocalDatasourceManager(this._db);
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
