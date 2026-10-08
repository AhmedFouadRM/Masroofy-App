import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/utils/currency_utils.dart';

/// Guards Localization PRD rule 3 (no orphaned keys) and that every
/// catalogue entry the code looks up by key has a string in both languages.
void main() {
  Map<String, dynamic> load(String lang) =>
      jsonDecode(File('assets/translations/$lang.json').readAsStringSync()) as Map<String, dynamic>;

  Set<String> flatten(Map<String, dynamic> json, [String prefix = '']) => {
        for (final MapEntry(:key, :value) in json.entries)
          if (value is Map<String, dynamic>) ...flatten(value, '$prefix$key.') else '$prefix$key',
      };

  final en = flatten(load('en'));
  final ar = flatten(load('ar'));

  test('en.json and ar.json have identical keys', () {
    expect(en.difference(ar), isEmpty, reason: 'missing in ar.json');
    expect(ar.difference(en), isEmpty, reason: 'missing in en.json');
  });

  test('every default category seed key has a name', () {
    for (final seed in DefaultCategories.seeds) {
      expect(en, contains('categories.${seed.seedKey}'));
    }
  });

  test('every supported currency has a name', () {
    for (final currency in CurrencyUtils.supported) {
      expect(en, contains('currencies.${currency.code}'));
    }
  });
}
