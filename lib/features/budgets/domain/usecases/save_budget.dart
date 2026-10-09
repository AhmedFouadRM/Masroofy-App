import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_draft.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';

/// Validates and creates (no `id`) or updates a budget.
class SaveBudget {
  SaveBudget(this._repository);

  final IBudgetRepository _repository;

  /// Returns the budget id.
  Future<Either<Failure, int>> call(BudgetDraft draft, {int? id}) async {
    if (draft.categoryId <= 0) {
      return const Left(ValidationFailure(field: 'categoryId', reason: ValidationReason.required));
    }
    if (!draft.limit.isPositive) {
      return const Left(ValidationFailure(field: 'limit', reason: ValidationReason.mustBePositive));
    }
    if (id == null) {
      return (await _repository.create(draft)).mapLeft(
        // The category already has a budget (unique index).
        (failure) => failure is ConstraintFailure
            ? const ValidationFailure(field: 'categoryId', reason: ValidationReason.duplicate)
            : failure,
      );
    }
    return (await _repository.update(id, draft)).map((_) => id);
  }
}
