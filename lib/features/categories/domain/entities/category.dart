import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String nameEn,
    String? nameAr,
    required String icon,
    required String color,
    @Default(false) bool isDefault,
    required DateTime createdAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  const Category._();

  String displayName(String languageCode) {
    if (languageCode == 'ar' && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return nameEn;
  }
}
