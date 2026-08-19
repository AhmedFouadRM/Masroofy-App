import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/categories/data/datasources/category_local_datasource.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final CategoryLocalDatasource _localDatasource;

  CategoryRepositoryImpl(this._localDatasource);

  // TODO: Implement methods
  @override
  Stream<Either<Failure, List<Category>>> watchAll() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, int>> insert(Category category) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> update(Category category) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> delete(int id) {
    throw UnimplementedError();
  }
}
