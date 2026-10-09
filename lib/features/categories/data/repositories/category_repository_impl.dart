import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/categories/data/datasources/category_local_datasource.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/entities/category_draft.dart';
import 'package:masroofy/features/categories/domain/entities/category_summary.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  CategoryRepositoryImpl(this._datasource);

  final CategoryLocalDatasource _datasource;

  @override
  Stream<Either<Failure, List<Category>>> watchAll({bool includeHidden = false}) =>
      _datasource.watchAll(includeHidden: includeHidden).map((rows) => rows.map(_toCategory).toList()).guarded();

  @override
  Stream<Either<Failure, List<CategorySummary>>> watchSummaries() =>
      _datasource.watchSummaries().map((rows) => rows.map(_toSummary).toList()).guarded();

  @override
  Future<Either<Failure, Category>> getById(int id) async => (await guardDb(() => _datasource.getById(id))).flatMap(
    (row) => row == null ? const Left(Failure.notFound()) : Right(_toCategory(row)),
  );

  @override
  Future<Either<Failure, CategorySummary>> getSummary(int id) async =>
      (await guardDb(() => _datasource.getSummary(id))).flatMap(
        (row) => row == null ? const Left(Failure.notFound()) : Right(_toSummary(row)),
      );

  @override
  Future<Either<Failure, List<String>>> customNames({int? excludeId}) =>
      guardDb(() => _datasource.customNames(excludeId: excludeId));

  @override
  Future<Either<Failure, int>> create(CategoryDraft draft) => guardDb(
    () => _datasource.insertCategory(
      name: draft.name,
      icon: draft.icon,
      color: draft.color,
      kind: draft.kind.name,
    ),
  );

  @override
  Future<Either<Failure, Unit>> update(int id, CategoryDraft draft) async {
    final summary = await getSummary(id);
    return summary.match(Left.new, (summary) async {
      // A category's kind is locked once anything uses it.
      if (summary.category.kind != draft.kind && summary.isInUse) {
        return const Left(ValidationFailure(field: 'kind', reason: ValidationReason.inUse));
      }
      return (await guardDb(
        () => _datasource.updateCategory(
          id,
          name: draft.name,
          icon: draft.icon,
          color: draft.color,
          kind: draft.kind.name,
        ),
      )).flatMap(_oneRowChanged);
    });
  }

  @override
  Future<Either<Failure, Unit>> delete(int id) async =>
      (await guardDb(() => _datasource.deleteCategory(id))).flatMap(_oneRowChanged);

  static Either<Failure, Unit> _oneRowChanged(int rows) =>
      rows == 1 ? const Right(unit) : const Left(Failure.notFound());

  static Category _toCategory(CategoriesTableData row) => Category(
    id: row.id,
    seedKey: row.seedKey,
    name: row.name,
    icon: row.icon,
    color: row.color,
    kind: TransactionKind.values.byName(row.kind),
    sortOrder: row.sortOrder,
    isHidden: row.isHidden,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  static CategorySummary _toSummary(CategorySummaryRow row) => CategorySummary(
    category: _toCategory(row.category),
    expenseCount: row.expenseCount,
    recurringCount: row.recurringCount,
    budgetLimit: row.budgetLimitMinor == null ? null : Money(row.budgetLimitMinor!),
    budgetPeriod: row.budgetPeriod == null ? null : BudgetPeriod.values.byName(row.budgetPeriod!),
  );
}
