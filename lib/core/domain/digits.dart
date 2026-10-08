/// Digit-shape helpers shared by amount and PIN input and by formatting.
///
/// Pure Dart: no Flutter or locale data, so it is safe to use in the domain layer.
library;

const _westernZero = 0x30; // '0'
const _arabicIndicZero = 0x0660; // '٠'
const _extendedArabicIndicZero = 0x06F0; // '۰' (Persian/Urdu shapes)

/// Arabic decimal separator `٫`.
const arabicDecimalSeparator = '٫';

/// Arabic thousands separator `٬`.
const arabicGroupSeparator = '٬';

/// Replaces Arabic-Indic and Extended Arabic-Indic digits with Western digits.
/// Any other character is left untouched.
String toWesternDigits(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    if (rune >= _arabicIndicZero && rune <= _arabicIndicZero + 9) {
      buffer.writeCharCode(_westernZero + rune - _arabicIndicZero);
    } else if (rune >= _extendedArabicIndicZero &&
        rune <= _extendedArabicIndicZero + 9) {
      buffer.writeCharCode(_westernZero + rune - _extendedArabicIndicZero);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}

/// Replaces Western digits with Arabic-Indic digits, and `.` / `,` with the
/// Arabic decimal / group separators. Intended for already-formatted numbers.
String toEasternArabicNumber(String formatted) {
  final buffer = StringBuffer();
  for (final rune in formatted.runes) {
    if (rune >= _westernZero && rune <= _westernZero + 9) {
      buffer.writeCharCode(_arabicIndicZero + rune - _westernZero);
    } else if (rune == 0x2E) {
      buffer.write(arabicDecimalSeparator);
    } else if (rune == 0x2C) {
      buffer.write(arabicGroupSeparator);
    } else {
      buffer.writeCharCode(rune);
    }
  }
  return buffer.toString();
}
