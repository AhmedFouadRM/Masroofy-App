import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/domain/entities/backup_preview.dart';
import 'package:masroofy/features/settings/domain/repositories/i_data_management_repository.dart';
import 'package:masroofy/features/settings/domain/repositories/i_file_services.dart';

/// Lets the user pick a backup file and checks it, before anything is
/// replaced. The UI confirms with the returned preview, then calls
/// `RestoreBackup`.
class PickBackup {
  PickBackup(this._picker, this._repository);

  final IBackupFilePicker _picker;
  final IDataManagementRepository _repository;

  /// Right(null) when the user cancelled the picker.
  Future<Either<Failure, PickedBackup?>> call() async {
    final picked = await _picker.pickBackupText();
    return picked.flatMap((json) {
      if (json == null) return const Right(null);
      return _repository.previewBackup(json).map((preview) => PickedBackup(json: json, preview: preview));
    });
  }
}
