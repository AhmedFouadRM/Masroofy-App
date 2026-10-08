import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';

class GetExpensesByDateRange {
  GetExpensesByDateRange(this._repository);

  final IExpenseRepository _repository;

  Stream<Either<Failure, List<Expense>>> call(LocalDate start, LocalDate end) {
    return _repository.watchExpensesByDateRange(start, end);
  }
}
