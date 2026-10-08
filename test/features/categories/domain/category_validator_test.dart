import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/category_icons.dart';
import 'package:masroofy/features/categories/domain/entities/category_draft.dart';
import 'package:masroofy/features/categories/domain/validation/category_validator.dart';

void main() {
  CategoryDraft draft(String name, {String icon = 'pets'}) => CategoryDraft(name: name, icon: icon, color: 0xFF000000);

  ValidationReason? reason(CategoryDraft d, [List<String> taken = const []]) =>
      CategoryValidator.validate(d, takenNames: taken)?.reason;

  test('accepts a valid name', () {
    expect(reason(draft('Gym')), isNull);
  });

  test('name is required after trimming', () {
    expect(reason(draft('   ')), ValidationReason.required);
  });

  test('name is at most 50 characters after trimming', () {
    expect(reason(draft('  ${'a' * 50}  ')), isNull);
    expect(reason(draft('a' * 51)), ValidationReason.tooLong);
  });

  test('duplicates are case-insensitive and whitespace-insensitive', () {
    expect(reason(draft('  my   GYM '), ['My Gym']), ValidationReason.duplicate);
  });

  test('default names in both languages are reserved', () {
    expect(reason(draft('food'), ['Food', 'طعام']), ValidationReason.duplicate);
    expect(reason(draft(' طعام '), ['Food', 'طعام']), ValidationReason.duplicate);
  });

  test('icon must be in the curated set', () {
    expect(reason(draft('Gym', icon: 'not_an_icon')), ValidationReason.invalidFormat);
    expect(CategoryIcons.keys.toSet(), hasLength(CategoryIcons.keys.length), reason: 'no duplicate keys');
  });
}
