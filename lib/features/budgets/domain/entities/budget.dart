import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';

part 'budget.freezed.dart';

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required int id,
    required int categoryId,
    required Money limit,
    required BudgetPeriod period,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Start of the period whose one-shot exceed alert was already shown.
    LocalDate? lastAlertedPeriodStart,
  }) = _Budget;
}
