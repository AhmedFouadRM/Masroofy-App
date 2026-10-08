import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

/// A default category has a [seedKey] (its name comes from the translation
/// files); a custom category has a user-typed [name]. Exactly one is set.
/// Resolving the display name needs translations, so it lives in presentation.
@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String icon,
    required int color,
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? seedKey,
    String? name,
    @Default(false) bool isHidden,
  }) = _Category;

  const Category._();

  bool get isDefault => seedKey != null;
}
