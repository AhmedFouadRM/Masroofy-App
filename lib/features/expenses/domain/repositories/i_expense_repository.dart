import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';

abstract interface class IExpenseRepository {
  /// The newest [limit] expenses matching [filter], by date then id,
  /// descending. Grow [limit] to load the next page.
  Stream<Either<Failure, List<Expense>>> watchExpenses(ExpenseFilter filter, {required int limit});

  /// Income and spending summed over every row matching [filter]. A
  /// [ExpenseFilter.kind] of one kind leaves the other at zero.
  Stream<Either<Failure, PeriodTotals>> watchTotals(ExpenseFilter filter);

  /// Per-day [watchTotals] of every row matching [filter] (days without rows
  /// are absent). Used for day headers, so they are right across pages.
  Stream<Either<Failure, Map<LocalDate, PeriodTotals>>> watchDailyTotals(ExpenseFilter filter);

  Future<Either<Failure, Expense>> getById(int id);

  /// Returns the new id. Fails with `ValidationFailure(categoryId, wrongKind)`
  /// when the category isn't of the draft's kind.
  Future<Either<Failure, int>> create(ExpenseDraft draft);

  Future<Either<Failure, Unit>> update(int id, ExpenseDraft draft);

  Future<Either<Failure, Unit>> delete(int id);
}
