// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: (json['id'] as num).toInt(),
  nameEn: json['nameEn'] as String,
  nameAr: json['nameAr'] as String?,
  icon: json['icon'] as String,
  color: json['color'] as String,
  isDefault: json['isDefault'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'nameEn': instance.nameEn,
  'nameAr': instance.nameAr,
  'icon': instance.icon,
  'color': instance.color,
  'isDefault': instance.isDefault,
  'createdAt': instance.createdAt.toIso8601String(),
};
