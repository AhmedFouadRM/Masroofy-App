import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';

extension CategoryDisplay on Category {
  /// Localized name for defaults (via `seed_key`), the typed name for custom ones.
  /// Reads the current locale, so call it inside `build`.
  String get displayName => isDefault ? StringManager.categoryName(seedKey!) : name!;
}
