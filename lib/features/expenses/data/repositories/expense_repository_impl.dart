import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';

class ExpenseRepositoryImpl implements IExpenseRepository {
  ExpenseRepositoryImpl(this._datasource);

  final ExpenseLocalDatasource _datasource;

  @override
  Stream<Either<Failure, List<Expense>>> watchExpenses(ExpenseFilter filter, {required int limit}) =>
      _datasource.watchExpenses(filter, limit: limit).map((rows) => rows.map(_toExpense).toList()).guarded();

  @override
  Stream<Either<Failure, Money>> watchTotal(ExpenseFilter filter) =>
      _datasource.watchTotal(filter).map(Money.new).guarded();

  @override
  Stream<Either<Failure, Map<LocalDate, Money>>> watchDailyTotals(ExpenseFilter filter) => _datasource
      .watchDailyTotals(filter)
      .map((totals) => totals.map((date, minor) => MapEntry(date, Money(minor))))
      .guarded();

  @override
  Future<Either<Failure, Expense>> getById(int id) async => (await guardDb(() => _datasource.getById(id))).flatMap(
    (row) => row == null ? const Left(Failure.notFound()) : Right(_toExpense(row)),
  );

  @override
  Future<Either<Failure, int>> create(ExpenseDraft draft) => guardDb(
    () => _datasource.insertExpense(
      ExpensesTableCompanion.insert(
        amountMinor: draft.amount.minor,
        categoryId: draft.categoryId,
        date: draft.date,
        title: Value(draft.title),
        note: Value(draft.note),
      ),
    ),
  );

  @override
  Future<Either<Failure, Unit>> update(int id, ExpenseDraft draft) async => (await guardDb(
    () => _datasource.updateExpense(
      id,
      ExpensesTableCompanion(
        amountMinor: Value(draft.amount.minor),
        categoryId: Value(draft.categoryId),
        date: Value(draft.date),
        title: Value(draft.title),
        note: Value(draft.note),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    ),
  )).flatMap(_oneRowChanged);

  @override
  Future<Either<Failure, Unit>> delete(int id) async =>
      (await guardDb(() => _datasource.deleteExpense(id))).flatMap(_oneRowChanged);

  static Either<Failure, Unit> _oneRowChanged(int rows) =>
      rows == 1 ? const Right(unit) : const Left(Failure.notFound());

  static Expense _toExpense(ExpensesTableData row) => Expense(
    id: row.id,
    amount: Money(row.amountMinor),
    categoryId: row.categoryId,
    date: row.date,
    title: row.title,
    note: row.note,
    recurringExpenseId: row.recurringExpenseId,
    occurrenceDate: row.occurrenceDate,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
