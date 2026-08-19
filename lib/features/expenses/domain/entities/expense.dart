import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
abstract class Expense with _$Expense {
  const factory Expense({
    required int id,
    required String title,
    required double amount,
    required int categoryId,
    required DateTime date,
    String? note,
    int? recurringExpenseId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
}
