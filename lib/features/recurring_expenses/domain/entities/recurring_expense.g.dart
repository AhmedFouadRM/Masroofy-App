// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringExpense _$RecurringExpenseFromJson(Map<String, dynamic> json) =>
    _RecurringExpense(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: (json['categoryId'] as num).toInt(),
      frequency: $enumDecode(_$RecurringFrequencyEnumMap, json['frequency']),
      startDate: DateTime.parse(json['startDate'] as String),
      nextDueDate: DateTime.parse(json['nextDueDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RecurringExpenseToJson(_RecurringExpense instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'categoryId': instance.categoryId,
      'frequency': _$RecurringFrequencyEnumMap[instance.frequency]!,
      'startDate': instance.startDate.toIso8601String(),
      'nextDueDate': instance.nextDueDate.toIso8601String(),
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$RecurringFrequencyEnumMap = {
  RecurringFrequency.daily: 'daily',
  RecurringFrequency.weekly: 'weekly',
  RecurringFrequency.monthly: 'monthly',
  RecurringFrequency.yearly: 'yearly',
};
