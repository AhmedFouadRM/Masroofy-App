import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';

/// Permanently deletes an expense. The list calls it only after the undo
/// window has passed (Expenses PRD → flow step 10).
class DeleteExpense {
  DeleteExpense(this._repository);

  final IExpenseRepository _repository;

  Future<Either<Failure, Unit>> call(int id) => _repository.delete(id);
}
