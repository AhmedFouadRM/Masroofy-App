import 'dart:ui' show PlatformDispatcher;

import 'package:drift/drift.dart' show OrderingTerm;
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
  static const authEnabled = 'auth_enabled';
  static const biometricEnabled = 'biometric_enabled';
  static const defaultWalletId = 'default_wallet_id';

  /// The wallet being viewed. Absent until the first launch has picked the
  /// default wallet; [allWallets] stores a choice of All wallets.
  static const viewedWalletId = 'viewed_wallet_id';

  /// Wallet ids start at 1, so 0 can stand for All wallets (`null` in state).
  static const allWallets = 0;
}

/// App-wide settings, provided above `MaterialApp` in `main()`. The initial
/// state is read synchronously from [SharedPreferences] loaded before `runApp`.
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required SharedPreferences preferences,
    required this._database,
    int? firstWeekday,
  }) : _preferences = preferences,
       super(_read(preferences, firstWeekday: firstWeekday ?? _deviceFirstWeekday()));

  final SharedPreferences _preferences;
  final AppDatabase _database;

  static SettingsState _read(SharedPreferences preferences, {required int firstWeekday}) => SettingsState(
    themeMode: ThemeMode.values.asNameMap()[preferences.getString(PreferenceKeys.themeMode)] ?? ThemeMode.system,
    currency:
        CurrencyUtils.byCode(preferences.getString(PreferenceKeys.currencyCode) ?? '') ?? CurrencyUtils.defaultCurrency,
    currencyChosen: preferences.containsKey(PreferenceKeys.currencyCode),
    westernDigits: preferences.getBool(PreferenceKeys.westernDigits) ?? false,
    firstWeekday: firstWeekday,
    defaultWalletId: preferences.getInt(PreferenceKeys.defaultWalletId),
    viewedWalletId: _viewedWallet(preferences),
  );

  static int? _viewedWallet(SharedPreferences preferences) {
    final id = preferences.getInt(PreferenceKeys.viewedWalletId);
    return id == PreferenceKeys.allWallets ? null : id;
  }

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

  /// First launch: stores the chosen currency and ends the first-launch step.
  /// The database is still empty, but this goes through [setCurrency] anyway
  /// so a restored or pre-seeded database is rescaled too.
  Future<void> completeFirstLaunch(Currency currency) async {
    await setCurrency(currency);
    await _preferences.setString(PreferenceKeys.currencyCode, currency.code);
    emit(state.copyWith(currencyChosen: true));
  }

  /// Re-reads the stored preferences, e.g. after a backup restore replaced them.
  /// `SharedPreferences` caches, so the restore must have written through the
  /// same instance (it does).
  void reload() => emit(_read(_preferences, firstWeekday: state.firstWeekday));

  Future<void> setWesternDigits({required bool enabled}) async {
    emit(state.copyWith(westernDigits: enabled));
    await _preferences.setBool(PreferenceKeys.westernDigits, enabled);
  }

  /// The wallet new transactions go to when All wallets is viewed.
  Future<void> setDefaultWallet(int id) async {
    emit(state.copyWith(defaultWalletId: id));
    await _preferences.setInt(PreferenceKeys.defaultWalletId, id);
  }

  /// The wallet the list and Analytics show; null shows All wallets. Remembered
  /// across launches.
  Future<void> setViewedWallet(int? id) async {
    emit(state.copyWith(viewedWalletId: id));
    await _preferences.setInt(PreferenceKeys.viewedWalletId, id ?? PreferenceKeys.allWallets);
  }

  /// Checks the wallet preferences against the wallets that exist. A missing
  /// or stale default becomes the first wallet (an upgraded or fresh install
  /// has only "Me"), a viewed wallet that was never chosen starts as the
  /// default one, and a viewed wallet that is gone becomes All wallets.
  /// Runs at launch, before the first screen.
  Future<void> repairWalletPreferences() async {
    final wallets = await (_database.select(
      _database.walletsTable,
    )..orderBy([(w) => OrderingTerm(expression: w.sortOrder), (w) => OrderingTerm(expression: w.id)])).get();
    final ids = [for (final wallet in wallets) wallet.id];
    if (ids.isEmpty) return;
    final defaultId = state.defaultWalletId;
    if (defaultId == null || !ids.contains(defaultId)) await setDefaultWallet(ids.first);
    final viewedId = state.viewedWalletId;
    if (!_preferences.containsKey(PreferenceKeys.viewedWalletId)) {
      await setViewedWallet(state.defaultWalletId);
    } else if (viewedId != null && !ids.contains(viewedId)) {
      await setViewedWallet(null);
    }
  }
}
