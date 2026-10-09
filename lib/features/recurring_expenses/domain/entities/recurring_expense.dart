import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';

part 'recurring_expense.freezed.dart';

@freezed
abstract class RecurringExpense with _$RecurringExpense {
  const factory RecurringExpense({
    required int id,
    required String title,
    required Money amount,
    required int categoryId,
    required RecurringFrequency frequency,

    /// Anchor: occurrence n is always computed from here, never chained.
    required LocalDate startDate,
    required LocalDate nextDueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(true) bool isActive,

    /// The category's kind: the rows it generates are income or expenses.
    @Default(TransactionKind.expense) TransactionKind kind,
  }) = _RecurringExpense;
}
