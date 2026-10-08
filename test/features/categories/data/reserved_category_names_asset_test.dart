import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/features/categories/data/datasources/reserved_category_names_asset.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('reads the default names of both languages from the translation files', () async {
    final names = await ReservedCategoryNamesAsset(rootBundle).load();

    expect(names, containsAll(['Food', 'Other', 'طعام', 'أخرى']));
    expect(names, hasLength(16));
    expect(names, isNot(contains('Categories')), reason: 'only seed keys, not other strings in the section');
  });
}
