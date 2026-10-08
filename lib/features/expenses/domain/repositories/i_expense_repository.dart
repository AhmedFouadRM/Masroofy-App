import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';

abstract interface class IExpenseRepository {
  /// The newest [limit] expenses matching [filter], by date then id,
  /// descending. Grow [limit] to load the next page.
  Stream<Either<Failure, List<Expense>>> watchExpenses(ExpenseFilter filter, {required int limit});

  /// Sum of every expense matching [filter].
  Stream<Either<Failure, Money>> watchTotal(ExpenseFilter filter);

  /// Per-day sums of every expense matching [filter] (days without expenses
  /// are absent). Used for day headers, so they are right across pages.
  Stream<Either<Failure, Map<LocalDate, Money>>> watchDailyTotals(ExpenseFilter filter);

  Future<Either<Failure, Expense>> getById(int id);

  /// Returns the new id.
  Future<Either<Failure, int>> create(ExpenseDraft draft);

  Future<Either<Failure, Unit>> update(int id, ExpenseDraft draft);

  Future<Either<Failure, Unit>> delete(int id);
}
