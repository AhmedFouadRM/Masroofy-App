import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/database/app_database.dart';
import '../core/constants/app_constants.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError('Initialize this in main() before runApp');
}

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  return AppDatabase();
}

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeStr = prefs.getString(_themeKey);
    if (themeStr == 'light') return ThemeMode.light;
    if (themeStr == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    ref.read(sharedPreferencesProvider).setString(_themeKey, mode.name);
  }
}

@Riverpod(keepAlive: true)
class CurrencyNotifier extends _$CurrencyNotifier {
  static const _currencyKey = 'currency_code';

  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(_currencyKey) ?? AppConstants.defaultCurrency;
  }

  void setCurrency(String code) {
    state = code;
    ref.read(sharedPreferencesProvider).setString(_currencyKey, code);
  }
}
