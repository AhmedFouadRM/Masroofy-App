import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';
import 'package:masroofy/features/expenses/domain/entities/list_entry.dart';

abstract interface class IExpenseRepository {
  /// The newest [limit] entries matching [filter], by date then id,
  /// descending. Grow [limit] to load the next page. A transfer is one entry:
  /// the wallet's own leg in a single wallet, the out leg in All wallets.
  Stream<Either<Failure, List<ListEntry>>> watchEntries(ExpenseFilter filter, {required int limit});

  /// Income and spending summed over every row matching [filter]. A
  /// [ExpenseFilter.kind] of one kind leaves the other at zero. Transfers are
  /// never income or spending; they only add to `transfersNet`.
  Stream<Either<Failure, PeriodTotals>> watchTotals(ExpenseFilter filter);

  /// Per-day [watchTotals] of every row matching [filter] (days without rows
  /// are absent). Used for day headers, so they are right across pages.
  Stream<Either<Failure, Map<LocalDate, PeriodTotals>>> watchDailyTotals(ExpenseFilter filter);

  /// The entry listed by `expenses` row [id]: a transaction, or a transfer
  /// when the row is one of its legs.
  Future<Either<Failure, ListEntry>> getEntry(int id);

  /// Returns the new id. Fails with `ValidationFailure(categoryId, wrongKind)`
  /// when the category isn't of the draft's kind.
  Future<Either<Failure, int>> create(ExpenseDraft draft);

  Future<Either<Failure, Unit>> update(int id, ExpenseDraft draft);

  /// Deletes row [id]; for a transfer leg, the whole transfer.
  Future<Either<Failure, Unit>> delete(int id);
}
