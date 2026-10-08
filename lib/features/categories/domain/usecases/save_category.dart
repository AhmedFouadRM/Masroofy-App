import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category_draft.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/categories/domain/validation/category_validator.dart';

/// Validates and creates (no `id`) or updates a custom category. The stored
/// name is trimmed with inner whitespace collapsed, but keeps its casing.
class SaveCategory {
  SaveCategory(this._repository, this._reservedNames);

  final ICategoryRepository _repository;
  final IReservedCategoryNames _reservedNames;

  /// Returns the category id.
  Future<Either<Failure, int>> call(CategoryDraft draft, {int? id}) async {
    final reserved = await _reservedNames.load();
    final custom = await _repository.customNames(excludeId: id);
    return custom.match(Left.new, (customNames) async {
      final failure = CategoryValidator.validate(draft, takenNames: [...reserved, ...customNames]);
      if (failure != null) return Left(failure);

      final cleaned = draft.copyWith(name: draft.name.trim().replaceAll(RegExp(r'\s+'), ' '));
      if (id == null) return _repository.create(cleaned);
      return (await _repository.update(id, cleaned)).map((_) => id);
    });
  }
}
