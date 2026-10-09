// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_import_local_datasource.dart';

// ignore_for_file: type=lint
mixin _$SmsImportLocalDatasourceMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTableTable get categoriesTable => attachedDatabase.categoriesTable;
  $WalletsTableTable get walletsTable => attachedDatabase.walletsTable;
  $RecurringExpensesTableTable get recurringExpensesTable =>
      attachedDatabase.recurringExpensesTable;
  $TransfersTableTable get transfersTable => attachedDatabase.transfersTable;
  $ExpensesTableTable get expensesTable => attachedDatabase.expensesTable;
  $SmsImportsTableTable get smsImportsTable => attachedDatabase.smsImportsTable;
  $MerchantCategoriesTableTable get merchantCategoriesTable =>
      attachedDatabase.merchantCategoriesTable;
  $TrustedSendersTableTable get trustedSendersTable =>
      attachedDatabase.trustedSendersTable;
  SmsImportLocalDatasourceManager get managers =>
      SmsImportLocalDatasourceManager(this);
}

class SmsImportLocalDatasourceManager {
  final _$SmsImportLocalDatasourceMixin _db;
  SmsImportLocalDatasourceManager(this._db);
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
  $$SmsImportsTableTableTableManager get smsImportsTable =>
      $$SmsImportsTableTableTableManager(
        _db.attachedDatabase,
        _db.smsImportsTable,
      );
  $$MerchantCategoriesTableTableTableManager get merchantCategoriesTable =>
      $$MerchantCategoriesTableTableTableManager(
        _db.attachedDatabase,
        _db.merchantCategoriesTable,
      );
  $$TrustedSendersTableTableTableManager get trustedSendersTable =>
      $$TrustedSendersTableTableTableManager(
        _db.attachedDatabase,
        _db.trustedSendersTable,
      );
}
