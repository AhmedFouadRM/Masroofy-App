import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/core/utils/date_utils.dart';
import 'package:masroofy/shared/settings/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

export 'package:masroofy/shared/settings/settings_state.dart';

abstract final class PreferenceKeys {
  static const currencyCode = 'currency_code';
  static const themeMode = 'theme_mode';
  static const westernDigits = 'western_digits';
}

/// App-wide settings, provided above `MaterialApp` in `main()`. The initial
/// state is read synchronously from [SharedPreferences] loaded before `runApp`.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required SharedPreferences preferences,
    required this._database,
    int? firstWeekday,
  }) : _preferences = preferences,
       super(
         SettingsState(
           themeMode:
               ThemeMode.values.asNameMap()[preferences.getString(
                 PreferenceKeys.themeMode,
               )] ??
               ThemeMode.system,
           currency:
               CurrencyUtils.byCode(
                 preferences.getString(PreferenceKeys.currencyCode) ?? '',
               ) ??
               CurrencyUtils.defaultCurrency,
           westernDigits:
               preferences.getBool(PreferenceKeys.westernDigits) ?? false,
           firstWeekday: firstWeekday ?? _deviceFirstWeekday(),
         ),
       );

  final SharedPreferences _preferences;
  final AppDatabase _database;

  static int _deviceFirstWeekday() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    return DateUtilsHelper.firstWeekdayFor(
      languageCode: deviceLocale.languageCode,
      countryCode: deviceLocale.countryCode,
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(state.copyWith(themeMode: mode));
    await _preferences.setString(PreferenceKeys.themeMode, mode.name);
  }

  /// Switches the app currency. Amounts are not converted, but when the
  /// fraction digits differ every stored amount is rescaled so its face value
  /// is preserved (12.50 EGP → 12.500 KWD). The UI must show the
  /// "amounts won't be converted" warning before calling this.
  Future<void> setCurrency(Currency currency) async {
    final previous = state.currency;
    if (previous == currency) return;
    await _database.rescaleAmounts(
      fromDigits: previous.fractionDigits,
      toDigits: currency.fractionDigits,
    );
    await _preferences.setString(PreferenceKeys.currencyCode, currency.code);
    emit(state.copyWith(currency: currency));
  }

  Future<void> setWesternDigits({required bool enabled}) async {
    emit(state.copyWith(westernDigits: enabled));
    await _preferences.setBool(PreferenceKeys.westernDigits, enabled);
  }
}
