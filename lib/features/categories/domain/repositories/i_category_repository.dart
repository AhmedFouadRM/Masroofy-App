import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/entities/category_draft.dart';
import 'package:masroofy/features/categories/domain/entities/category_summary.dart';

abstract interface class ICategoryRepository {
  /// Categories for pickers: defaults first, then custom, by `sort_order`.
  Stream<Either<Failure, List<Category>>> watchAll({bool includeHidden = false});

  /// Every category with its usage counts and budget, for Manage Categories.
  Stream<Either<Failure, List<CategorySummary>>> watchSummaries();

  Future<Either<Failure, Category>> getById(int id);

  Future<Either<Failure, CategorySummary>> getSummary(int id);

  /// Names of the custom categories, except [excludeId] (the one being edited).
  Future<Either<Failure, List<String>>> customNames({int? excludeId});

  /// Appends a custom category after the existing ones. Returns its id.
  Future<Either<Failure, int>> create(CategoryDraft draft);

  Future<Either<Failure, Unit>> update(int id, CategoryDraft draft);

  /// In one transaction: moves the category's expenses and recurring
  /// templates to **Other**, deletes its budget, then deletes it.
  Future<Either<Failure, Unit>> delete(int id);
}

/// The default category names in **every** supported language ("Food",
/// "طعام", ...). A custom name may not collide with any of them. An
/// interface (not a function) so it can be registered and faked.
// ignore: one_member_abstracts
abstract interface class IReservedCategoryNames {
  Future<Set<String>> load();
}
