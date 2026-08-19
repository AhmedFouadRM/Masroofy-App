import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';

abstract class ICategoryRepository {
  /// Watch all categories
  Stream<Either<Failure, List<Category>>> watchAll();

  /// Insert a new category
  Future<Either<Failure, int>> insert(Category category);

  /// Update an existing category
  Future<Either<Failure, bool>> update(Category category);

  /// Delete a category by ID
  Future<Either<Failure, bool>> delete(int id);
}
