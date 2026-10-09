import 'dart:convert';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/domain/repositories/i_data_management_repository.dart';
import 'package:masroofy/features/settings/domain/repositories/i_file_services.dart';

/// Writes `masroofix_backup_YYYY-MM-DD.json` and opens the share sheet.
class ExportBackup {
  ExportBackup(this._repository, this._sharer, {LocalDate Function()? today}) : _today = today ?? LocalDate.today;

  final IDataManagementRepository _repository;
  final IFileSharer _sharer;
  final LocalDate Function() _today;

  Future<Either<Failure, Unit>> call() async {
    final created = await _repository.createBackup();
    return created.match(
      (failure) async => Left(failure),
      (json) => _sharer.share(
        fileName: 'masroofix_backup_${_today().toIso()}.json',
        bytes: Uint8List.fromList(utf8.encode(json)),
        mimeType: 'application/json',
      ),
    );
  }
}
