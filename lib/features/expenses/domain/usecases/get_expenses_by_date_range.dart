import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';

class GetExpensesByDateRange {
  final IExpenseRepository _repository;

  GetExpensesByDateRange(this._repository);

  Stream<Either<Failure, List<Expense>>> call(DateTime start, DateTime end) {
    return _repository.watchExpensesByDateRange(start, end);
  }
}
