import 'package:masroofy/core/domain/digits.dart';
import 'package:meta/meta.dart';

/// An amount in the user's single currency, stored as integer **minor units**
/// (e.g. 12.50 EGP → 1250, 1.250 KWD → 1250).
///
/// Never use `double` for money: float sums drift, and currencies differ in
/// precision. The number of fraction digits belongs to the currency, so it is
/// supplied when parsing, formatting, or rescaling — not stored here.
@immutable
final class Money implements Comparable<Money> {
  const Money(this.minor);

  static const zero = Money(0);

  /// Largest accepted integer part when parsing user input (999,999,999).
  static const maxIntegerDigits = 9;

  final int minor;

  bool get isPositive => minor > 0;
  bool get isNegative => minor < 0;

  Money operator +(Money other) => Money(minor + other.minor);
  Money operator -(Money other) => Money(minor - other.minor);
  Money operator -() => Money(-minor);
  bool operator <(Money other) => minor < other.minor;
  bool operator <=(Money other) => minor <= other.minor;
  bool operator >(Money other) => minor > other.minor;
  bool operator >=(Money other) => minor >= other.minor;

  /// Sum of [amounts]; [zero] when empty.
  static Money sum(Iterable<Money> amounts) =>
      amounts.fold(zero, (total, amount) => total + amount);

  /// Parses user input such as `12.5`, `1,234.50`, `١٢٫٥` or `۱۲.۵`.
  ///
  /// Accepts Western and Arabic-Indic digits, `.` or `٫` as the decimal
  /// separator, and `,` / `٬` / spaces as group separators. Returns `null` for
  /// empty, negative, malformed input, more fraction digits than
  /// [fractionDigits], or more than [maxIntegerDigits] integer digits.
  static Money? tryParse(String input, {required int fractionDigits}) {
    final normalized = toWesternDigits(input)
        .trim()
        .replaceAll(arabicDecimalSeparator, '.')
        .replaceAll(RegExp(r'[,٬\s]'), '');
    final match = RegExp(r'^(\d*)(?:\.(\d*))?$').firstMatch(normalized);
    if (match == null) return null;

    final integerPart = match.group(1)!;
    final fractionPart = match.group(2) ?? '';
    if (integerPart.isEmpty && fractionPart.isEmpty) return null;
    if (fractionPart.length > fractionDigits) return null;

    final trimmedInteger = integerPart.replaceFirst(RegExp('^0+'), '');
    if (trimmedInteger.length > maxIntegerDigits) return null;

    final paddedFraction = fractionPart.padRight(fractionDigits, '0');
    return Money(int.parse('${trimmedInteger.isEmpty ? '0' : trimmedInteger}$paddedFraction'));
  }

  /// Plain decimal string with Western digits, `.` separator and no grouping,
  /// e.g. `12.50` or `-1.250`. Used for CSV export and form pre-fill.
  String toDecimalString(int fractionDigits) {
    final sign = minor < 0 ? '-' : '';
    final digits = minor.abs().toString().padLeft(fractionDigits + 1, '0');
    if (fractionDigits == 0) return '$sign$digits';
    final split = digits.length - fractionDigits;
    return '$sign${digits.substring(0, split)}.${digits.substring(split)}';
  }

  /// Converts between currencies with different fraction digits while keeping
  /// the face value (12.50 → 12.500). When digits are dropped the value is
  /// rounded half away from zero.
  Money rescale({required int fromDigits, required int toDigits}) {
    if (fromDigits == toDigits) return this;
    if (toDigits > fromDigits) {
      return Money(minor * _pow10(toDigits - fromDigits));
    }
    final divisor = _pow10(fromDigits - toDigits);
    final half = divisor ~/ 2;
    final rounded = minor >= 0 ? (minor + half) ~/ divisor : -((-minor + half) ~/ divisor);
    return Money(rounded);
  }

  static int _pow10(int exponent) {
    var result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }

  @override
  int compareTo(Money other) => minor.compareTo(other.minor);

  @override
  bool operator ==(Object other) => other is Money && other.minor == minor;

  @override
  int get hashCode => minor.hashCode;

  @override
  String toString() => 'Money($minor)';
}
