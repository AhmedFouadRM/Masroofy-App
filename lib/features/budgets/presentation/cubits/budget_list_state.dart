import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';

part 'budget_list_state.freezed.dart';

enum BudgetListStatus { loading, loaded, failure }

@freezed
abstract class BudgetListState with _$BudgetListState {
  const factory BudgetListState({
    @Default(BudgetListStatus.loading) BudgetListStatus status,
    @Default(<BudgetProgress>[]) List<BudgetProgress> budgets,

    /// Every category (hidden ones too), by id.
    @Default(<int, Category>{}) Map<int, Category> categories,
    Failure? loadFailure,

    /// A delete that failed; the row was restored.
    Failure? actionFailure,
  }) = _BudgetListState;

  const BudgetListState._();

  /// Every visible category already has a budget, so Add has nothing to offer.
  bool get allBudgeted {
    final budgeted = {for (final b in budgets) b.budget.categoryId};
    return categories.values.where((c) => !c.isHidden).every((c) => budgeted.contains(c.id));
  }
}
