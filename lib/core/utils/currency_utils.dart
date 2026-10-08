import 'package:masroofy/core/domain/digits.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:meta/meta.dart';

/// One entry of the supported-currency catalogue.
///
/// Display names are not stored here: they live in the translation files
/// (`currencies.<code>`) and are read through `StringManager.currencyName`.
@immutable
final class Currency {
  const Currency({
    required this.code,
    required this.fractionDigits,
    required this.symbolEn,
    required this.symbolAr,
  });

  /// ISO 4217 code, e.g. `EGP`.
  final String code;

  /// Minor-unit digits: 2 for EGP/USD, 3 for KWD/BHD/OMR/JOD.
  final int fractionDigits;

  final String symbolEn;
  final String symbolAr;

  @override
  bool operator ==(Object other) => other is Currency && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => code;
}

class CurrencyUtils {
  CurrencyUtils._();

  static const defaultCode = 'EGP';

  /// The V1 catalogue (see Settings PRD → Currency Catalogue).
  static const List<Currency> supported = [
    Currency(code: 'EGP', fractionDigits: 2, symbolEn: 'EGP', symbolAr: 'ج.م.'),
    Currency(code: 'SAR', fractionDigits: 2, symbolEn: 'SAR', symbolAr: 'ر.س.'),
    Currency(code: 'AED', fractionDigits: 2, symbolEn: 'AED', symbolAr: 'د.إ.'),
    Currency(code: 'QAR', fractionDigits: 2, symbolEn: 'QAR', symbolAr: 'ر.ق.'),
    Currency(code: 'KWD', fractionDigits: 3, symbolEn: 'KWD', symbolAr: 'د.ك.'),
    Currency(code: 'BHD', fractionDigits: 3, symbolEn: 'BHD', symbolAr: 'د.ب.'),
    Currency(code: 'OMR', fractionDigits: 3, symbolEn: 'OMR', symbolAr: 'ر.ع.'),
    Currency(code: 'JOD', fractionDigits: 3, symbolEn: 'JOD', symbolAr: 'د.أ.'),
    Currency(code: 'MAD', fractionDigits: 2, symbolEn: 'MAD', symbolAr: 'د.م.'),
    Currency(code: 'USD', fractionDigits: 2, symbolEn: r'$', symbolAr: r'$'),
    Currency(code: 'EUR', fractionDigits: 2, symbolEn: '€', symbolAr: '€'),
    Currency(code: 'GBP', fractionDigits: 2, symbolEn: '£', symbolAr: '£'),
  ];

  static Currency get defaultCurrency => byCode(defaultCode)!;

  static Currency? byCode(String code) {
    for (final currency in supported) {
      if (currency.code == code) return currency;
    }
    return null;
  }

  /// Formats [amount] for display.
  ///
  /// English: `EGP 1,234.56`, `$1,234.56`. Arabic: `١٬٢٣٤٫٥٦ ج.م.`, or
  /// `1,234.56 ج.م.` when [westernDigits] is set. Digits are produced here
  /// rather than by `intl` so the output is identical on every device.
  ///
  /// Whole amounts drop their zero fraction (`EGP 520`, not `EGP 520.00`);
  /// any other amount keeps all of the currency's digits (`EGP 12.50`).
  static String format(
    Money amount,
    Currency currency, {
    required String languageCode,
    bool westernDigits = false,
  }) {
    final full = formatNumber(amount, currency);
    final dot = full.indexOf('.');
    final isWhole = dot != -1 && full.substring(dot + 1).split('').every((digit) => digit == '0');
    final number = isWhole ? full.substring(0, dot) : full;
    if (languageCode == 'ar') {
      final shaped = westernDigits ? number : toEasternArabicNumber(number);
      return '$shaped ${currency.symbolAr}';
    }
    final separator = currency.symbolEn.length == 1 ? '' : ' ';
    return '${currency.symbolEn}$separator$number';
  }

  /// Grouped number with Western digits, every fraction digit and no
  /// symbol, e.g. `-1,234.50`. For exports and form pre-fill; on screen use
  /// [format].
  static String formatNumber(Money amount, Currency currency) {
    final plain = amount.toDecimalString(currency.fractionDigits);
    final negative = plain.startsWith('-');
    final unsigned = negative ? plain.substring(1) : plain;
    final dot = unsigned.indexOf('.');
    final integerPart = dot == -1 ? unsigned : unsigned.substring(0, dot);
    final fractionPart = dot == -1 ? '' : unsigned.substring(dot);

    final grouped = StringBuffer();
    for (var i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) grouped.write(',');
      grouped.write(integerPart[i]);
    }
    return '${negative ? '-' : ''}$grouped$fractionPart';
  }
}
