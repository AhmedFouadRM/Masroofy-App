import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';

part 'expense.freezed.dart';

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required int id,
    required Money amount,
    required int categoryId,
    required LocalDate date,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Optional; when null the UI shows the category's display name.
    String? title,
    String? note,
    int? recurringExpenseId,

    /// Template due date this entry was generated for (recurring only).
    LocalDate? occurrenceDate,
  }) = _Expense;

  const Expense._();

  bool get isRecurringGenerated => occurrenceDate != null;
}
