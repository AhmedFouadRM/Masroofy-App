import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';
import 'package:masroofy/features/recurring_expenses/data/datasources/recurring_expense_local_datasource.dart';

class RecurringExpenseRepositoryImpl implements IRecurringExpenseRepository {
  final RecurringExpenseLocalDatasource _localDatasource;

  RecurringExpenseRepositoryImpl(this._localDatasource);

  // TODO: Implement methods
  @override
  Stream<Either<Failure, List<RecurringExpense>>> watchAll() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<RecurringExpense>>> getDueRecurringExpenses(LocalDate today) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> insert(RecurringExpense recurringExpense) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> update(RecurringExpense recurringExpense) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> delete(int id) {
    throw UnimplementedError();
  }
}
