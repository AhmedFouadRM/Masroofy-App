import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';

part 'budget_draft.freezed.dart';

/// The user-editable fields of a budget, as entered in the form. The
/// category can't change after the budget is created.
@freezed
abstract class BudgetDraft with _$BudgetDraft {
  const factory BudgetDraft({required int categoryId, required Money limit, required BudgetPeriod period}) =
      _BudgetDraft;
}
