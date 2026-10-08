import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/category_icons.dart';
import 'package:masroofy/features/categories/domain/entities/category_draft.dart';

/// Field rules from the Categories PRD → Validation Rules.
abstract final class CategoryValidator {
  /// Compares names case-insensitively, ignoring surrounding and repeated
  /// whitespace ("  My  Gym " == "my gym").
  static String normalize(String name) => name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  /// Returns the first failing rule, or `null` when [draft] is valid.
  /// [takenNames] holds the other custom names and the reserved default
  /// names in every language; they are normalized here.
  static ValidationFailure? validate(CategoryDraft draft, {required Iterable<String> takenNames}) {
    final name = normalize(draft.name);
    if (name.isEmpty) {
      return const ValidationFailure(field: 'name', reason: ValidationReason.required);
    }
    if (name.length > AppConstants.maxCategoryNameLength) {
      return const ValidationFailure(field: 'name', reason: ValidationReason.tooLong);
    }
    if (takenNames.map(normalize).contains(name)) {
      return const ValidationFailure(field: 'name', reason: ValidationReason.duplicate);
    }
    if (!CategoryIcons.keys.contains(draft.icon)) {
      return const ValidationFailure(field: 'icon', reason: ValidationReason.invalidFormat);
    }
    return null;
  }
}
