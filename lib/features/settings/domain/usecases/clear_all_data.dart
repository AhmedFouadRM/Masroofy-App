import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/domain/repositories/i_data_management_repository.dart';

/// Deletes all user data once the two-step confirmation passed. Preferences
/// and App Lock are kept (Settings PRD → Clear All Data).
class ClearAllData {
  ClearAllData(this._repository);

  final IDataManagementRepository _repository;

  Future<Either<Failure, Unit>> call() => _repository.clearAllData();
}
