import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/utils/currency_utils.dart';

void main() {
  final egp = CurrencyUtils.byCode('EGP')!;
  final usd = CurrencyUtils.byCode('USD')!;
  final kwd = CurrencyUtils.byCode('KWD')!;

  group('catalogue', () {
    test('defaults to EGP and has unique codes', () {
      expect(CurrencyUtils.defaultCurrency, egp);
      final codes = CurrencyUtils.supported.map((c) => c.code);
      expect(codes.toSet(), hasLength(codes.length));
      expect(CurrencyUtils.byCode('XYZ'), isNull);
    });

    test('three-decimal currencies are marked as such', () {
      for (final code in ['KWD', 'BHD', 'OMR', 'JOD']) {
        expect(CurrencyUtils.byCode(code)!.fractionDigits, 3, reason: code);
      }
      expect(egp.fractionDigits, 2);
    });
  });

  group('format', () {
    const amount = Money(123456);

    test('English puts the symbol first', () {
      expect(CurrencyUtils.format(amount, egp, languageCode: 'en'), 'EGP 1,234.56');
      expect(CurrencyUtils.format(amount, usd, languageCode: 'en'), r'$1,234.56');
      expect(CurrencyUtils.format(const Money(1250), kwd, languageCode: 'en'), 'KWD 1.250');
    });

    test('Arabic uses Eastern digits by default, Western on request', () {
      expect(CurrencyUtils.format(amount, egp, languageCode: 'ar'), '١٬٢٣٤٫٥٦ ج.م.');
      expect(
        CurrencyUtils.format(amount, egp, languageCode: 'ar', westernDigits: true),
        '1,234.56 ج.م.',
      );
    });

    test('negative and small values', () {
      expect(CurrencyUtils.format(const Money(-123456), egp, languageCode: 'en'), 'EGP -1,234.56');
      expect(CurrencyUtils.formatNumber(const Money(5), egp), '0.05');
    });

    test('whole amounts drop the zero fraction on screen, others keep every digit', () {
      expect(CurrencyUtils.format(const Money(52000), egp, languageCode: 'en'), 'EGP 520');
      expect(CurrencyUtils.format(const Money(1250), egp, languageCode: 'en'), 'EGP 12.50');
      expect(CurrencyUtils.format(const Money(1000), kwd, languageCode: 'en'), 'KWD 1');
      expect(CurrencyUtils.format(const Money(1010), kwd, languageCode: 'en'), 'KWD 1.010');
      expect(CurrencyUtils.format(const Money(200000), egp, languageCode: 'ar'), '٢٬٠٠٠ ج.م.');
      expect(CurrencyUtils.format(Money.zero, egp, languageCode: 'en'), 'EGP 0');
      // Exports keep full precision.
      expect(CurrencyUtils.formatNumber(const Money(100000000), egp), '1,000,000.00');
      expect(CurrencyUtils.formatNumber(const Money(100), egp), '1.00');
    });
  });
}
