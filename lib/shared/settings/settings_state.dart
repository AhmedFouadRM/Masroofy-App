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
  }) = _SettingsState;
}
