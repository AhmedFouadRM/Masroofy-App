import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/expenses/domain/validation/expense_validator.dart';

class UpdateExpense {
  UpdateExpense(this._repository);

  final IExpenseRepository _repository;

  Future<Either<Failure, bool>> call(Expense expense, {LocalDate? today}) async {
    final failure = ExpenseValidator.validate(expense, today: today ?? LocalDate.today());
    if (failure != null) return Left(failure);
    return _repository.updateExpense(expense);
  }
}
