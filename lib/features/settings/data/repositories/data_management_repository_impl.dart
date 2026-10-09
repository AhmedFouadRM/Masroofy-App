import 'package:flutter/material.dart' show ThemeMode;
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/data/backup_codec.dart';
import 'package:masroofy/features/settings/data/datasources/data_management_local_datasource.dart';
import 'package:masroofy/features/settings/domain/entities/backup_preview.dart';
import 'package:masroofy/features/settings/domain/entities/expense_export_row.dart';
import 'package:masroofy/features/settings/domain/repositories/i_data_management_repository.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart' show PreferenceKeys;
import 'package:shared_preferences/shared_preferences.dart';

class DataManagementRepositoryImpl implements IDataManagementRepository {
  DataManagementRepositoryImpl(this._datasource, this._preferences, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final DataManagementLocalDatasource _datasource;
  final SharedPreferences _preferences;
  final DateTime Function() _now;

  static const _invalidBackup = Failure.validation(field: 'backup', reason: ValidationReason.invalidFormat);

  @override
  Future<Either<Failure, List<ExpenseExportRow>>> loadExpenseExport() => guardDb(() async {
    return [
      for (final (:expense, :category) in await _datasource.loadExpensesWithCategory())
        ExpenseExportRow(
          date: expense.date,
          amount: Money(expense.amountMinor),
          title: expense.title,
          categorySeedKey: category.seedKey,
          categoryName: category.name,
          note: expense.note,
          isRecurring: expense.occurrenceDate != null,
        ),
    ];
  });

  @override
  Future<Either<Failure, String>> createBackup() => guardDb(() async {
    final snapshot = await _datasource.readSnapshot();
    return BackupCodec.encode(
      snapshot,
      BackupPreferences(
        currencyCode: _preferences.getString(PreferenceKeys.currencyCode) ?? CurrencyUtils.defaultCode,
        themeMode: _preferences.getString(PreferenceKeys.themeMode) ?? ThemeMode.system.name,
        westernDigits: _preferences.getBool(PreferenceKeys.westernDigits) ?? false,
      ),
      exportedAt: _now(),
    );
  });

  @override
  Either<Failure, BackupPreview> previewBackup(String json) {
    try {
      return Right(BackupCodec.preview(BackupCodec.decode(json)));
    } on FormatException {
      return const Left(_invalidBackup);
    }
  }

  @override
  Future<Either<Failure, Unit>> restoreBackup(String json) async {
    final DecodedBackup backup;
    try {
      // Everything is validated before the first write.
      backup = BackupCodec.decode(json);
    } on FormatException {
      return const Left(_invalidBackup);
    }
    return guardDb(() async {
      await _datasource.replaceAll(backup.snapshot);
      // The data is in; now the preferences it was made with, so the amounts
      // and the currency's fraction digits agree.
      await _preferences.setString(PreferenceKeys.currencyCode, backup.preferences.currencyCode);
      await _preferences.setString(PreferenceKeys.themeMode, backup.preferences.themeMode);
      await _preferences.setBool(PreferenceKeys.westernDigits, backup.preferences.westernDigits);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> clearAllData() => guardDb(() async {
    await _datasource.clearAll();
    return unit;
  });
}
