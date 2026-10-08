import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';

/// All date ranges are inclusive calendar dates.
abstract class IExpenseRepository {
  /// Watch all expenses within a date range, ordered by date descending
  Stream<Either<Failure, List<Expense>>> watchExpensesByDateRange(
    LocalDate start,
    LocalDate end,
  );

  /// Watch total spending for a date range
  Stream<Either<Failure, Money>> watchTotalForDateRange(
    LocalDate start,
    LocalDate end,
  );

  /// Watch total spending grouped by category id for a date range
  Stream<Either<Failure, Map<int, Money>>> watchTotalByCategory(
    LocalDate start,
    LocalDate end,
  );

  /// Watch daily totals for a date range
  Stream<Either<Failure, Map<LocalDate, Money>>> watchDailyTotals(
    LocalDate start,
    LocalDate end,
  );

  /// Insert a new expense
  Future<Either<Failure, int>> insertExpense(Expense expense);

  /// Update an existing expense
  Future<Either<Failure, bool>> updateExpense(Expense expense);

  /// Delete an expense by ID
  Future<Either<Failure, bool>> deleteExpense(int id);
}
