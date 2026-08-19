import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';
import 'package:masroofy/features/budgets/data/datasources/budget_local_datasource.dart';

class BudgetRepositoryImpl implements IBudgetRepository {
  final BudgetLocalDatasource _localDatasource;

  BudgetRepositoryImpl(this._localDatasource);

  // TODO: Implement methods
  @override
  Stream<Either<Failure, List<Budget>>> watchAll() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> insert(Budget budget) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> update(Budget budget) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> delete(int id) {
    throw UnimplementedError();
  }
}
