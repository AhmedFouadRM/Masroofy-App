import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';

part 'category_summary.freezed.dart';

/// A category with what references it: drives the Manage Categories rows
/// ("42 expenses · budget EGP 2,000") and the delete confirmation copy.
@freezed
abstract class CategorySummary with _$CategorySummary {
  const factory CategorySummary({
    required Category category,
    required int expenseCount,
    required int recurringCount,
    Money? budgetLimit,
    BudgetPeriod? budgetPeriod,
  }) = _CategorySummary;

  const CategorySummary._();

  bool get isInUse => expenseCount > 0 || recurringCount > 0 || budgetLimit != null;
}
