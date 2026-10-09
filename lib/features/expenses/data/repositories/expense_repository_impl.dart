import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';
import 'package:masroofy/features/expenses/domain/entities/list_entry.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer.dart';

class ExpenseRepositoryImpl implements IExpenseRepository {
  ExpenseRepositoryImpl(this._datasource);

  final ExpenseLocalDatasource _datasource;

  @override
  Stream<Either<Failure, List<ListEntry>>> watchEntries(ExpenseFilter filter, {required int limit}) =>
      _datasource.watchExpenses(filter, limit: limit).map((rows) => rows.map(_toEntry).toList()).guarded();

  @override
  Stream<Either<Failure, PeriodTotals>> watchTotals(ExpenseFilter filter) =>
      _datasource.watchTotals(filter).map(_toTotals).guarded();

  @override
  Stream<Either<Failure, Map<LocalDate, PeriodTotals>>> watchDailyTotals(ExpenseFilter filter) =>
      _datasource.watchDailyTotals(filter).map((totals) => totals.map((d, t) => MapEntry(d, _toTotals(t)))).guarded();

  @override
  Future<Either<Failure, ListEntry>> getEntry(int id) async => (await guardDb(() => _datasource.getById(id))).flatMap(
    (row) => row == null ? const Left(Failure.notFound()) : Right(_toEntry(row)),
  );

  @override
  Future<Either<Failure, int>> create(ExpenseDraft draft) async {
    final wrongKind = await _wrongKind(draft);
    if (wrongKind != null) return Left(wrongKind);
    return guardDb(
      () => _datasource.insertExpense(
        ExpensesTableCompanion.insert(
          amountMinor: draft.amount.minor,
          walletId: draft.walletId,
          categoryId: Value(draft.categoryId),
          date: draft.date,
          title: Value(draft.title),
          note: Value(draft.note),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> update(int id, ExpenseDraft draft) async {
    final wrongKind = await _wrongKind(draft);
    if (wrongKind != null) return Left(wrongKind);
    return (await guardDb(
      () => _datasource.updateExpense(
        id,
        ExpensesTableCompanion(
          amountMinor: Value(draft.amount.minor),
          walletId: Value(draft.walletId),
          categoryId: Value(draft.categoryId),
          date: Value(draft.date),
          title: Value(draft.title),
          note: Value(draft.note),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      ),
    )).flatMap(_oneRowChanged);
  }

  /// The category must be of the draft's kind. A missing category is left to
  /// the foreign key.
  Future<Failure?> _wrongKind(ExpenseDraft draft) async {
    final kind = (await guardDb(() => _datasource.categoryKind(draft.categoryId))).getOrElse((_) => null);
    return kind == null || kind == draft.kind.name
        ? null
        : const ValidationFailure(field: 'categoryId', reason: ValidationReason.wrongKind);
  }

  @override
  Future<Either<Failure, Unit>> delete(int id) async =>
      (await guardDb(() => _datasource.deleteExpense(id))).flatMap(_oneRowChanged);

  static Either<Failure, Unit> _oneRowChanged(int rows) =>
      rows == 1 ? const Right(unit) : const Left(Failure.notFound());

  static PeriodTotals _toTotals(MinorTotals totals) => PeriodTotals(
    income: Money(totals.income),
    spent: Money(totals.spent),
    transfersNet: Money(totals.transfersNet),
  );

  static ListEntry _toEntry(ExpenseRow result) {
    final row = result.expense;
    final transferId = row.transferId;
    if (transferId != null) {
      // The leg is the out leg when the wallet is the source.
      final out = row.direction == 'out';
      final other = result.counterpartWalletId ?? row.walletId;
      return ListEntry.transfer(
        Transfer(
          id: transferId,
          fromWalletId: out ? row.walletId : other,
          toWalletId: out ? other : row.walletId,
          amount: Money(row.amountMinor),
          date: row.date,
          note: row.note,
          createdAt: row.createdAt,
          updatedAt: row.updatedAt,
        ),
        rowId: row.id,
        walletId: row.walletId,
      );
    }
    return ListEntry.transaction(
      Expense(
        id: row.id,
        amount: Money(row.amountMinor),
        walletId: row.walletId,
        categoryId: row.categoryId!,
        date: row.date,
        title: row.title,
        note: row.note,
        recurringExpenseId: row.recurringExpenseId,
        occurrenceDate: row.occurrenceDate,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        kind: TransactionKind.values.byName(result.kind!),
      ),
    );
  }
}
