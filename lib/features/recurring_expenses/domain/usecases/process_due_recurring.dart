import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';

class ProcessDueRecurring {
  final IRecurringExpenseRepository _repository;

  ProcessDueRecurring(this._repository);

  Future<Either<Failure, Unit>> call() async {
    // TODO: Implement auto-generation logic
    // 1. Get due recurring expenses
    // 2. Insert as normal expenses
    // 3. Update nextDueDate for recurring expenses
    return const Right(unit);
  }
}
