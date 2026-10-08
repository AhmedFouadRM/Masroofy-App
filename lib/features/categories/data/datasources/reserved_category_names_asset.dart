import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';

/// Reads the default category names of every language straight from the
/// translation files, so they stay the single source of truth.
/// easy_localization only loads the current locale, hence the direct read.
class ReservedCategoryNamesAsset implements IReservedCategoryNames {
  ReservedCategoryNamesAsset(this._bundle, {this.languageCodes = const ['en', 'ar']});

  final AssetBundle _bundle;
  final List<String> languageCodes;
  Future<Set<String>>? _names;

  @override
  Future<Set<String>> load() => _names ??= _read();

  Future<Set<String>> _read() async {
    final names = <String>{};
    for (final code in languageCodes) {
      final json = jsonDecode(await _bundle.loadString('assets/translations/$code.json')) as Map<String, dynamic>;
      final categories = json['categories'] as Map<String, dynamic>;
      for (final seed in DefaultCategories.seeds) {
        if (categories[seed.seedKey] case final String name) names.add(name);
      }
    }
    return names;
  }
}
