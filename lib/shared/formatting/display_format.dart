import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/digits.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/core/utils/date_utils.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';

/// Locale- and settings-aware formatting for widgets: Eastern Arabic digits
/// in Arabic unless the user chose Western digits, and the app currency.
/// Rebuilds the caller when the language, digits or currency change, so call
/// these inside `build`.
extension DisplayFormat on BuildContext {
  bool get _arabic => locale.languageCode == 'ar';

  bool get _westernDigits => select<SettingsCubit, bool>((cubit) => cubit.state.westernDigits);

  /// The app currency.
  Currency get currency => select<SettingsCubit, Currency>((cubit) => cubit.state.currency);

  /// The currency as shown next to amounts: `EGP` / `ج.م.`.
  String get currencyLabel => _arabic ? currency.symbolAr : currency.code;

  /// A plain count: `12` / `١٢`.
  String count(int value) => digits('$value');

  /// Shapes the digits of already-formatted text for the locale.
  String digits(String text) => _arabic && !_westernDigits ? toEasternArabicNumber(text) : text;

  /// An amount in the app currency: `EGP 2,000.00` / `٢٬٠٠٠٫٠٠ ج.م.`.
  String money(Money amount) =>
      CurrencyUtils.format(amount, currency, languageCode: locale.languageCode, westernDigits: _westernDigits);

  /// An amount with its sign before the number in both directions:
  /// `+EGP 5,000` / `+٥٬٠٠٠ ج.م.`, `−EGP 200` for a negative one. Zero has no
  /// sign, and [plus] `false` leaves positive amounts bare. In Arabic only
  /// the sign and number sit in an LTR isolate, so the sign stays on the
  /// number and the currency follows it as in unsigned amounts.
  String signedMoney(Money amount, {bool plus = true}) {
    final sign = amount.isNegative ? '−' : (plus && amount.isPositive ? '+' : '');
    final magnitude = amount.isNegative ? -amount : amount;
    if (sign.isEmpty) return money(magnitude);
    if (locale.languageCode == 'ar') return '\u2066$sign${this.amount(magnitude)}\u2069 ${currency.symbolAr}';
    return '$sign${money(magnitude)}';
  }

  /// An amount without the currency: `1,320` / `١٬٣٢٠`.
  String amount(Money amount) =>
      CurrencyUtils.formatAmount(amount, currency, languageCode: locale.languageCode, westernDigits: _westernDigits);

  /// `Oct 8` / `٨ أكتوبر`.
  String shortDate(LocalDate date) =>
      DateUtilsHelper.formatShortDate(date, languageCode: locale.languageCode, westernDigits: _westernDigits);

  /// `Oct 8, 2026` / `٨ أكتوبر ٢٠٢٦`.
  String longDate(LocalDate date) =>
      DateUtilsHelper.formatDate(date, languageCode: locale.languageCode, westernDigits: _westernDigits);

  /// List header: Today, Yesterday, then the date (with the year when it
  /// isn't this year's).
  String dayLabel(LocalDate day, {required LocalDate today}) {
    if (day == today) return StringManager.today;
    if (day == today.addDays(-1)) return StringManager.yesterday;
    return day.year == today.year ? shortDate(day) : longDate(day);
  }
}
