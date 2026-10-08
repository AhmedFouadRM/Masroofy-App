import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/money.dart';

void main() {
  group('Money.tryParse', () {
    Money? parse(String input, [int digits = 2]) => Money.tryParse(input, fractionDigits: digits);

    test('parses Western input with optional grouping and whitespace', () {
      expect(parse('12.5'), const Money(1250));
      expect(parse('1,234.50'), const Money(123450));
      expect(parse(' 12 '), const Money(1200));
      expect(parse('.5'), const Money(50));
      expect(parse('5.'), const Money(500));
      expect(parse('007'), const Money(700));
    });

    test('parses Arabic-Indic and Extended Arabic-Indic digits', () {
      expect(parse('١٢٫٥'), const Money(1250));
      expect(parse('١٬٢٣٤٫٥٠'), const Money(123450));
      expect(parse('۱۲.۵'), const Money(1250));
    });

    test('respects the currency fraction digits', () {
      expect(parse('0.125', 3), const Money(125));
      expect(parse('1.25', 3), const Money(1250));
      expect(parse('12', 0), const Money(12));
      expect(parse('12.345'), isNull);
      expect(parse('12.5', 0), isNull);
    });

    test('rejects empty, negative, malformed and oversized input', () {
      for (final input in ['', '   ', '.', '-5', 'abc', '1.2.3', '12a']) {
        expect(parse(input), isNull, reason: input);
      }
      expect(parse('999999999.999', 3), const Money(999999999999));
      expect(parse('1234567890'), isNull);
    });
  });

  group('Money arithmetic', () {
    test('summing 10,000 × 0.10 is exactly 1,000.00 (no float drift)', () {
      final total = Money.sum(List.filled(10000, const Money(10)));
      expect(total, const Money(100000));
      expect(total.toDecimalString(2), '1000.00');
    });

    test('operators and comparison', () {
      const a = Money(1250);
      const b = Money(250);
      expect(a + b, const Money(1500));
      expect(b - a, const Money(-1000));
      expect((b - a).isNegative, isTrue);
      expect(a > b, isTrue);
      expect([a, b]..sort(), [b, a]);
      expect(Money.sum([]), Money.zero);
    });
  });

  group('Money.toDecimalString', () {
    test('pads and places the separator by fraction digits', () {
      expect(const Money(1250).toDecimalString(2), '12.50');
      expect(const Money(5).toDecimalString(3), '0.005');
      expect(const Money(-1250).toDecimalString(3), '-1.250');
      expect(const Money(12).toDecimalString(0), '12');
      expect(Money.zero.toDecimalString(2), '0.00');
    });
  });

  group('Money.rescale', () {
    test('adding digits keeps face value', () {
      expect(const Money(1250).rescale(fromDigits: 2, toDigits: 3), const Money(12500));
    });

    test('dropping digits rounds half away from zero', () {
      expect(const Money(12505).rescale(fromDigits: 3, toDigits: 2), const Money(1251));
      expect(const Money(12504).rescale(fromDigits: 3, toDigits: 2), const Money(1250));
      expect(const Money(-12505).rescale(fromDigits: 3, toDigits: 2), const Money(-1251));
    });

    test('same digits is a no-op', () {
      expect(const Money(42).rescale(fromDigits: 2, toDigits: 2), const Money(42));
    });
  });
}
