import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';

part 'recurring_expense.freezed.dart';
part 'recurring_expense.g.dart';

@freezed
abstract class RecurringExpense with _$RecurringExpense {
  const factory RecurringExpense({
    required int id,
    required String title,
    required double amount,
    required int categoryId,
    required RecurringFrequency frequency,
    required DateTime startDate,
    required DateTime nextDueDate,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _RecurringExpense;

  factory RecurringExpense.fromJson(Map<String, dynamic> json) => _$RecurringExpenseFromJson(json);
}
