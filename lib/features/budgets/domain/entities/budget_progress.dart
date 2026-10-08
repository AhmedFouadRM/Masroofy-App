import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/budgets/domain/entities/budget.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';

part 'budget_progress.freezed.dart';

enum BudgetStatus { safe, warning, exceeded }

/// Spend vs limit for one budget's **current** period. Computed at read time,
/// never stored.
@freezed
abstract class BudgetProgress with _$BudgetProgress {
  const factory BudgetProgress({
    required Budget budget,
    required Category category,
    required LocalDate periodStart,
    required LocalDate periodEnd,
    required Money spent,
  }) = _BudgetProgress;

  const BudgetProgress._();

  /// Fraction of the budget at which the bar turns amber.
  static const warningRatio = 0.8;

  /// Negative when over budget.
  Money get remaining => budget.limit - spent;

  /// 1.0 == 100% of the limit.
  double get ratio => spent.minor / budget.limit.minor;

  /// Exceeded strictly means spent > limit; exactly 100% is still a warning.
  BudgetStatus get status {
    if (spent > budget.limit) return BudgetStatus.exceeded;
    if (ratio >= warningRatio) return BudgetStatus.warning;
    return BudgetStatus.safe;
  }
}
