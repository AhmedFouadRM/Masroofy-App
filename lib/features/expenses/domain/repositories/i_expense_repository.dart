import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';

abstract class IExpenseRepository {
  /// Watch all expenses within a date range, ordered by date descending
  Stream<Either<Failure, List<Expense>>> watchExpensesByDateRange(
    DateTime start,
    DateTime end,
  );

  /// Watch total spending for a date range
  Stream<Either<Failure, double>> watchTotalForDateRange(
    DateTime start,
    DateTime end,
  );

  /// Watch total spending grouped by category for a date range
  Stream<Either<Failure, Map<int, double>>> watchTotalByCategory(
    DateTime start,
    DateTime end,
  );

  /// Watch daily totals for a date range
  Stream<Either<Failure, Map<DateTime, double>>> watchDailyTotals(
    DateTime start,
    DateTime end,
  );

  /// Insert a new expense
  Future<Either<Failure, int>> insertExpense(Expense expense);

  /// Update an existing expense
  Future<Either<Failure, bool>> updateExpense(Expense expense);

  /// Delete an expense by ID
  Future<Either<Failure, bool>> deleteExpense(int id);
}
