import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/domain/entities/expense_export_row.dart';

/// Names a row's category in the current UI language.
typedef CategoryLabeler = String Function({String? seedKey, String? name});

/// The expenses CSV (Settings PRD → CSV Export Format): RFC 4180, comma
/// delimited, CRLF rows. Column names and `Yes`/`No` stay in English so the
/// file reads the same whatever the UI language.
abstract final class CsvExport {
  static const header = ['Date', 'Title', 'Amount', 'Currency', 'Category', 'Note', 'Recurring'];

  /// Excel needs a UTF-8 byte order mark to read Arabic text correctly.
  static const bom = [0xEF, 0xBB, 0xBF];

  /// A field, quoted when it holds a comma, a quote, or a line break (RFC 4180
  /// §2): quotes inside are doubled.
  static String escapeField(String value) {
    if (!value.contains(RegExp('[",\r\n]'))) return value;
    return '"${value.replaceAll('"', '""')}"';
  }

  /// [rows] as CSV text: every line, the last included, ends in CRLF.
  static String encode(Iterable<List<String>> rows) {
    final buffer = StringBuffer();
    for (final row in rows) {
      buffer
        ..writeAll(row.map(escapeField), ',')
        ..write('\r\n');
    }
    return buffer.toString();
  }

  /// The header and one record per expense, in the order given. Amounts are
  /// plain decimals with `.`, the currency's fraction digits and Western
  /// digits; dates are ISO 8601.
  static List<List<String>> records(
    Iterable<ExpenseExportRow> expenses,
    Currency currency,
    CategoryLabeler categoryLabel,
  ) => [
    header,
    for (final e in expenses)
      [
        e.date.toIso(),
        e.title ?? '',
        e.amount.toDecimalString(currency.fractionDigits),
        currency.code,
        categoryLabel(seedKey: e.categorySeedKey, name: e.categoryName),
        e.note ?? '',
        if (e.isRecurring) 'Yes' else 'No',
      ],
  ];
}
