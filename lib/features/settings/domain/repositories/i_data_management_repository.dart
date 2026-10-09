import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/domain/entities/backup_preview.dart';
import 'package:masroofy/features/settings/domain/entities/expense_export_row.dart';

/// Whole-database operations behind the Settings → Data tiles.
abstract interface class IDataManagementRepository {
  /// Every expense with its category, oldest first.
  Future<Either<Failure, List<ExpenseExportRow>>> loadExpenseExport();

  /// A versioned JSON backup of all data and preferences (never the PIN).
  Future<Either<Failure, String>> createBackup();

  /// Validates [json] without changing anything. A [ValidationFailure] with
  /// field `backup` means it isn't a usable Masroofy backup.
  Either<Failure, BackupPreview> previewBackup(String json);

  /// Replaces all data and the stored preferences with [json]'s, in one
  /// transaction, after validating all of it. Any failure leaves the data as it was.
  Future<Either<Failure, Unit>> restoreBackup(String json);

  /// Deletes all expenses, categories, budgets and recurring templates, then
  /// re-seeds the default categories. Preferences and App Lock are kept.
  Future<Either<Failure, Unit>> clearAllData();
}
