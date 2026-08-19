import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget.dart';

abstract class IBudgetRepository {
  Stream<Either<Failure, List<Budget>>> watchAll();
  Future<Either<Failure, int>> insert(Budget budget);
  Future<Either<Failure, bool>> update(Budget budget);
  Future<Either<Failure, bool>> delete(int id);
}
