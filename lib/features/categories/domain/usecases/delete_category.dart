import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';

/// Deletes a custom category; its expenses and templates move to Other and
/// its budget is removed. Default categories can never be deleted.
class DeleteCategory {
  DeleteCategory(this._repository);

  final ICategoryRepository _repository;

  Future<Either<Failure, Unit>> call(int id) async {
    final category = await _repository.getById(id);
    return category.match(Left.new, (category) {
      if (category.isDefault) {
        return const Left(Failure.constraint(message: 'Default categories cannot be deleted'));
      }
      return _repository.delete(id);
    });
  }
}
