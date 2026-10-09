import 'dart:convert';

import 'package:flutter/services.dart' show AssetBundle;
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The strings of SMS notifications, in the app language.
///
/// A notification can be posted while the app is closed, where
/// `easy_localization` is not running. So this reads the language the app
/// saved (`locale` in the preferences, written by easy_localization) and the
/// same `assets/translations/<language>.json` the app uses, straight from the
/// asset bundle.
class SmsNotificationTexts {
  SmsNotificationTexts._(this.languageCode, this._strings, {required this.westernDigits});

  /// Builds texts from an already-loaded translation map (for tests).
  SmsNotificationTexts.fromMap(
    Map<String, dynamic> translations, {
    this.languageCode = 'en',
    this.westernDigits = false,
  }) : _strings = translations;

  static const _path = 'assets/translations';

  final String languageCode;
  final bool westernDigits;
  final Map<String, dynamic> _strings;

  /// Reads the language and digits setting from [preferences] and loads the
  /// matching translations from [bundle]. Falls back to English.
  static Future<SmsNotificationTexts> load(SharedPreferences preferences, AssetBundle bundle) async {
    await preferences.reload();
    final saved = preferences.getString('locale')?.split(RegExp('[_-]')).first;
    final code = saved == 'ar' ? 'ar' : 'en';
    final json = await bundle.loadString('$_path/$code.json');
    return SmsNotificationTexts._(
      code,
      jsonDecode(json) as Map<String, dynamic>,
      westernDigits: preferences.getBool('western_digits') ?? false,
    );
  }

  /// The string at the dotted [key] (`sms.notification.add`), with each `{}`
  /// replaced by the next of [args]. The key itself when missing.
  String t(String key, [List<String> args = const []]) {
    Object? node = _strings;
    for (final part in key.split('.')) {
      node = node is Map<String, dynamic> ? node[part] : null;
    }
    var text = node is String ? node : key;
    for (final arg in args) {
      text = text.replaceFirst('{}', arg);
    }
    return text;
  }

  /// `EGP 450` / `٤٥٠ ج.م.`; for a currency the app does not list, the code
  /// and the number.
  String money(Money amount, String currencyCode) {
    final currency = CurrencyUtils.byCode(currencyCode);
    if (currency == null) return '$currencyCode ${amount.toDecimalString(2)}';
    return CurrencyUtils.format(amount, currency, languageCode: languageCode, westernDigits: westernDigits);
  }
}
