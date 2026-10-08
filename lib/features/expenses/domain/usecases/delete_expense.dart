import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';

class DeleteExpense {
  DeleteExpense(this._repository);

  final IExpenseRepository _repository;

  Future<Either<Failure, bool>> call(int id) async {
    if (id <= 0) {
      return const Left(Failure.validation(field: 'id', reason: ValidationReason.invalidFormat));
    }
    return _repository.deleteExpense(id);
  }
}
