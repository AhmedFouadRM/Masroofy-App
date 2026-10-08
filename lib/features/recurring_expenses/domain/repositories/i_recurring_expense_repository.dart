import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';

abstract class IRecurringExpenseRepository {
  Stream<Either<Failure, List<RecurringExpense>>> watchAll();
  Future<Either<Failure, List<RecurringExpense>>> getDueRecurringExpenses(LocalDate today);
  Future<Either<Failure, int>> insert(RecurringExpense recurringExpense);
  Future<Either<Failure, bool>> update(RecurringExpense recurringExpense);
  Future<Either<Failure, bool>> delete(int id);
}
