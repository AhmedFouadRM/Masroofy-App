import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required int id,
    required double amount,
    int? categoryId, // If null, applies to overall budget
    required BudgetPeriod period,
    required DateTime createdAt,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}
