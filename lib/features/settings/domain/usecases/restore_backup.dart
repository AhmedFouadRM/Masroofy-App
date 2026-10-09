import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/domain/repositories/i_data_management_repository.dart';

/// Replaces all data with a backup the user confirmed.
class RestoreBackup {
  RestoreBackup(this._repository);

  final IDataManagementRepository _repository;

  Future<Either<Failure, Unit>> call(String json) => _repository.restoreBackup(json);
}
