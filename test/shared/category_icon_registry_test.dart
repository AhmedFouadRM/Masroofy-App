import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/categories/domain/category_icons.dart';
import 'package:masroofy/shared/categories/category_icon_registry.dart';

void main() {
  test('every icon key has a glyph, and every glyph a key', () {
    expect(CategoryIconRegistry.icons.keys.toSet(), CategoryIcons.keys.toSet());
  });

  test('default categories use registered icons', () {
    for (final seed in DefaultCategories.seeds) {
      expect(CategoryIcons.keys, contains(seed.icon));
    }
  });

  test('unknown keys fall back to more_horiz', () {
    expect(CategoryIconRegistry.of('nope'), CategoryIconRegistry.icons['more_horiz']);
  });
}
