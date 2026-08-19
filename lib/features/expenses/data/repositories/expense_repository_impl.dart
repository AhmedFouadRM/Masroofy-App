import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/expenses/data/datasources/expense_local_datasource.dart';

class ExpenseRepositoryImpl implements IExpenseRepository {
  final ExpenseLocalDatasource _localDatasource;

  ExpenseRepositoryImpl(this._localDatasource);

  // TODO: Implement methods
  @override
  Stream<Either<Failure, List<Expense>>> watchExpensesByDateRange(DateTime start, DateTime end) {
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, double>> watchTotalForDateRange(DateTime start, DateTime end) {
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, Map<int, double>>> watchTotalByCategory(DateTime start, DateTime end) {
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, Map<DateTime, double>>> watchDailyTotals(DateTime start, DateTime end) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> insertExpense(Expense expense) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> updateExpense(Expense expense) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> deleteExpense(int id) {
    throw UnimplementedError();
  }
}
