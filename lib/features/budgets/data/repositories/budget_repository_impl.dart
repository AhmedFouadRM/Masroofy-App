import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/data/datasources/budget_local_datasource.dart';
import 'package:masroofy/features/budgets/domain/entities/budget.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_draft.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';

class BudgetRepositoryImpl implements IBudgetRepository {
  BudgetRepositoryImpl(this._datasource);

  final BudgetLocalDatasource _datasource;

  @override
  Stream<Either<Failure, List<BudgetProgress>>> watchProgress(LocalDate today, {required int firstWeekday}) {
    final week = BudgetPeriod.weekly.windowFor(today, firstWeekday: firstWeekday);
    final month = BudgetPeriod.monthly.windowFor(today, firstWeekday: firstWeekday);
    return _datasource
        .watchWithSpend(week: week, month: month)
        .map((rows) => [for (final row in rows) _toProgress(row, week: week, month: month)])
        .guarded();
  }

  static BudgetProgress _toProgress(BudgetSpendRow row, {required DateRange week, required DateRange month}) {
    final budget = _toBudget(row.budget);
    final window = budget.period == BudgetPeriod.weekly ? week : month;
    return BudgetProgress(budget: budget, periodStart: window.start, periodEnd: window.end, spent: Money(row.spent));
  }

  @override
  Future<Either<Failure, Budget>> getById(int id) async => (await guardDb(
    () => _datasource.getById(id),
  )).flatMap((row) => row == null ? const Left(Failure.notFound()) : Right(_toBudget(row)));

  @override
  Future<Either<Failure, int>> create(BudgetDraft draft) async {
    // Budgets are spending limits: income categories can't have one.
    final kind = (await guardDb(() => _datasource.categoryKind(draft.categoryId))).getOrElse((_) => null);
    if (kind == TransactionKind.income.name) {
      return const Left(ValidationFailure(field: 'categoryId', reason: ValidationReason.invalidFormat));
    }
    return guardDb(
      () => _datasource.insertBudget(
        BudgetsTableCompanion.insert(
          categoryId: draft.categoryId,
          limitMinor: draft.limit.minor,
          period: draft.period.name,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> update(int id, BudgetDraft draft) async => (await guardDb(
    () => _datasource.updateBudget(
      id,
      BudgetsTableCompanion(
        limitMinor: Value(draft.limit.minor),
        period: Value(draft.period.name),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    ),
  )).flatMap(_oneRowChanged);

  @override
  Future<Either<Failure, Unit>> delete(int id) async =>
      (await guardDb(() => _datasource.deleteBudget(id))).flatMap(_oneRowChanged);

  @override
  Future<Either<Failure, Unit>> markAlerted(int id, LocalDate periodStart) async =>
      (await guardDb(() => _datasource.markAlerted(id, periodStart))).flatMap(_oneRowChanged);

  static Either<Failure, Unit> _oneRowChanged(int rows) =>
      rows == 1 ? const Right(unit) : const Left(Failure.notFound());

  static Budget _toBudget(BudgetsTableData row) => Budget(
    id: row.id,
    categoryId: row.categoryId,
    limit: Money(row.limitMinor),
    period: BudgetPeriod.values.byName(row.period),
    lastAlertedPeriodStart: row.lastAlertedPeriodStart,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
