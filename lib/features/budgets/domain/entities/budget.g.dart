// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => _Budget(
  id: (json['id'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  categoryId: (json['categoryId'] as num?)?.toInt(),
  period: $enumDecode(_$BudgetPeriodEnumMap, json['period']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'categoryId': instance.categoryId,
  'period': _$BudgetPeriodEnumMap[instance.period]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$BudgetPeriodEnumMap = {
  BudgetPeriod.weekly: 'weekly',
  BudgetPeriod.monthly: 'monthly',
};
