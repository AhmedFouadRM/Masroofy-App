import 'package:meta/meta.dart';

/// What a backup file holds, shown in the restore confirmation.
@immutable
final class BackupPreview {
  const BackupPreview({
    required this.exportedAt,
    required this.expenses,
    required this.categories,
    required this.budgets,
    required this.recurring,
  });

  final DateTime exportedAt;
  final int expenses;
  final int categories;
  final int budgets;
  final int recurring;
}

/// A backup file read from disk and checked: its text, kept to restore from
/// after the user confirms, and what it holds.
@immutable
final class PickedBackup {
  const PickedBackup({required this.json, required this.preview});

  final String json;
  final BackupPreview preview;
}
