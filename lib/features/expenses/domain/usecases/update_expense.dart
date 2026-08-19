import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';

class UpdateExpense {
  final IExpenseRepository _repository;

  UpdateExpense(this._repository);

  Future<Either<Failure, bool>> call(Expense expense) async {
    // Validate
    if (expense.title.trim().isEmpty) {
      return const Left(Failure.validation(message: 'Title is required'));
    }
    if (expense.title.length > AppConstants.maxTitleLength) {
      return const Left(Failure.validation(message: 'Title is too long'));
    }
    if (expense.amount <= 0) {
      return const Left(Failure.validation(message: 'Amount must be greater than zero'));
    }
    if (expense.date.isAfter(DateTime.now())) {
      return const Left(Failure.validation(message: 'Date cannot be in the future'));
    }
    if (expense.note != null && expense.note!.length > AppConstants.maxNoteLength) {
      return const Left(Failure.validation(message: 'Note is too long'));
    }

    return _repository.updateExpense(expense);
  }
}
