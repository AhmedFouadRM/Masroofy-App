import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';

/// Deletes a budget after the user confirmed.
class DeleteBudget {
  DeleteBudget(this._repository);

  final IBudgetRepository _repository;

  Future<Either<Failure, Unit>> call(int id) => _repository.delete(id);
}
