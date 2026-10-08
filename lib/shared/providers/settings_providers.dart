import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart' show ThemeMode;
import 'package:masroofy/core/database/database_provider.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/core/utils/date_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_providers.g.dart';

/// App-wide user preferences. Locale is deliberately absent: easy_localization
/// persists it and is the single source of truth (`context.locale`).
abstract final class PreferenceKeys {
  static const currencyCode = 'currency_code';
  static const themeMode = 'theme_mode';
  static const westernDigits = 'western_digits';
}

/// Overridden in `main()` with the instance loaded before `runApp`.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('sharedPreferencesProvider must be overridden in main()');

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final stored = ref.watch(sharedPreferencesProvider).getString(PreferenceKeys.themeMode);
    return ThemeMode.values.asNameMap()[stored] ?? ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.read(sharedPreferencesProvider).setString(PreferenceKeys.themeMode, mode.name);
  }
}

@Riverpod(keepAlive: true)
class CurrencyNotifier extends _$CurrencyNotifier {
  @override
  Currency build() {
    final stored = ref.watch(sharedPreferencesProvider).getString(PreferenceKeys.currencyCode);
    return CurrencyUtils.byCode(stored ?? '') ?? CurrencyUtils.defaultCurrency;
  }

  /// Switches the app currency. Amounts are not converted, but when the
  /// fraction digits differ every stored amount is rescaled so its face value
  /// is preserved (12.50 EGP → 12.500 KWD). The UI must show the
  /// "amounts won't be converted" warning before calling this.
  Future<void> setCurrency(Currency currency) async {
    final previous = state;
    if (previous == currency) return;
    await ref.read(appDatabaseProvider).rescaleAmounts(
          fromDigits: previous.fractionDigits,
          toDigits: currency.fractionDigits,
        );
    await ref.read(sharedPreferencesProvider).setString(PreferenceKeys.currencyCode, currency.code);
    state = currency;
  }
}

/// Show Western digits (123) instead of Eastern Arabic digits (١٢٣) in Arabic.
@Riverpod(keepAlive: true)
class WesternDigitsNotifier extends _$WesternDigitsNotifier {
  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(PreferenceKeys.westernDigits) ?? false;

  Future<void> setWesternDigits({required bool enabled}) async {
    state = enabled;
    await ref.read(sharedPreferencesProvider).setBool(PreferenceKeys.westernDigits, enabled);
  }
}

/// First day of the week as a `DateTime.weekday` value, from the device
/// region (not the app language): Saturday in Egypt, Sunday in Saudi Arabia.
@Riverpod(keepAlive: true)
int firstWeekday(Ref ref) {
  final deviceLocale = PlatformDispatcher.instance.locale;
  return DateUtilsHelper.firstWeekdayFor(
    languageCode: deviceLocale.languageCode,
    countryCode: deviceLocale.countryCode,
  );
}
