import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/features/budgets/domain/entities/budget.dart';

part 'budget_progress.freezed.dart';

enum BudgetStatus {
  good,
  warning,
  exceeded
}

@freezed
abstract class BudgetProgress with _$BudgetProgress {
  const factory BudgetProgress({
    required Budget budget,
    required double spent,
    required double remaining,
    required double percentage,
    required BudgetStatus status,
  }) = _BudgetProgress;
}
