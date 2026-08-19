// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  amount: (json['amount'] as num).toDouble(),
  categoryId: (json['categoryId'] as num).toInt(),
  date: DateTime.parse(json['date'] as String),
  note: json['note'] as String?,
  recurringExpenseId: (json['recurringExpenseId'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'amount': instance.amount,
  'categoryId': instance.categoryId,
  'date': instance.date.toIso8601String(),
  'note': instance.note,
  'recurringExpenseId': instance.recurringExpenseId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
