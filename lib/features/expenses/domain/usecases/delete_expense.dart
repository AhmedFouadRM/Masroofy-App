import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';

class DeleteExpense {
  final IExpenseRepository _repository;
  
  DeleteExpense(this._repository);

  Future<Either<Failure, bool>> call(int id) async {
    if (id <= 0) {
      return const Left(Failure.validation(message: 'Invalid expense ID'));
    }
    return _repository.deleteExpense(id);
  }
}
