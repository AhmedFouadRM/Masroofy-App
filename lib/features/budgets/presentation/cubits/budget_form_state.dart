import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';

part 'budget_form_state.freezed.dart';

enum BudgetFormStatus { loading, ready, saving, saved, loadFailure }

@freezed
abstract class BudgetFormState with _$BudgetFormState {
  const factory BudgetFormState({
    /// Fraction digits of the app currency (2 for EGP, 3 for KWD).
    required int fractionDigits,
    @Default(BudgetFormStatus.loading) BudgetFormStatus status,

    /// Null for a new budget.
    int? id,
    int? categoryId,

    /// As typed: Western or Arabic-Indic digits, `.` or `٫`.
    @Default('') String limitText,
    @Default(BudgetPeriod.monthly) BudgetPeriod period,

    /// Visible categories (for the picker and the locked edit field).
    @Default(<Category>[]) List<Category> categories,

    /// Categories that already have a budget, left out of the picker.
    @Default(<int>{}) Set<int> budgeted,

    /// Field errors, keyed by `categoryId`, `limit`.
    @Default(<String, ValidationReason>{}) Map<String, ValidationReason> errors,

    /// A load or save failure other than a field error.
    Failure? failure,
  }) = _BudgetFormState;

  const BudgetFormState._();

  bool get isEditing => id != null;

  Category? get category => categories.where((c) => c.id == categoryId).firstOrNull;

  /// What the picker offers: categories without a budget.
  List<Category> get available => [
    for (final c in categories)
      if (!budgeted.contains(c.id)) c,
  ];

  bool get canSave => status == BudgetFormStatus.ready;
}
