import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/utils/currency_utils.dart';

part 'settings_state.freezed.dart';

/// App-wide user preferences. Locale is deliberately absent: easy_localization
/// persists it and is the single source of truth (`context.locale`).
@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    required ThemeMode themeMode,
    required Currency currency,

    /// Show Western digits (123) instead of Eastern Arabic digits (١٢٣) in Arabic.
    required bool westernDigits,

    /// First day of the week as a `DateTime.weekday` value, from the device
    /// region (not the app language): Saturday in Egypt, Sunday in Saudi Arabia.
    required int firstWeekday,

    /// False until the user has picked a currency on first launch. Defaults to
    /// true so a state built without it (tests) skips the first-launch step.
    @Default(true) bool currencyChosen,

    /// The wallet new transactions go to when All wallets is viewed. Null only
    /// until the app has checked it against the wallets (a fresh install).
    int? defaultWalletId,

    /// The wallet the Transactions list and Analytics show; null is All wallets.
    int? viewedWalletId,

    /// SMS Import (Android) is on. Shown as the value of the Settings row.
    @Default(false) bool smsEnabled,
  }) = _SettingsState;
}
