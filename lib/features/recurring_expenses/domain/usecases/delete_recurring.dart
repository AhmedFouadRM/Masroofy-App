import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';

/// Deletes a template after the user confirmed. Expenses it generated stay.
class DeleteRecurring {
  DeleteRecurring(this._repository);

  final IRecurringExpenseRepository _repository;

  Future<Either<Failure, Unit>> call(int id) => _repository.delete(id);
}
