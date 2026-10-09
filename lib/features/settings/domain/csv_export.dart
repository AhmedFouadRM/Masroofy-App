import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/domain/entities/expense_export_row.dart';

/// Names a row's category in the current UI language.
typedef CategoryLabeler = String Function({String? seedKey, String? name});

/// Names a row's wallet in the current UI language.
typedef WalletLabeler = String Function({String? seedKey, String? name});

/// The transactions CSV (Settings PRD → CSV Export Format): RFC 4180, comma
/// delimited, CRLF rows. Column names, `expense`/`income`/`transfer` and
/// `Yes`/`No` stay in English so the file reads the same whatever the UI
/// language. A transfer is one row: type `transfer`, its source wallet in
/// Wallet and its target wallet in Transfer (empty for every other row).
abstract final class CsvExport {
  static const header = [
    'Date',
    'Type',
    'Title',
    'Amount',
    'Currency',
    'Category',
    'Wallet',
    'Transfer',
    'Note',
    'Recurring',
  ];

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

  /// The header and one record per transaction, in the order given. Amounts
  /// are positive plain decimals with `.`, the currency's fraction digits and
  /// Western digits (the Type column says which way the money went); dates are
  /// ISO 8601.
  static List<List<String>> records(
    Iterable<ExpenseExportRow> expenses,
    Currency currency,
    CategoryLabeler categoryLabel,
    WalletLabeler walletLabel,
  ) => [
    header,
    for (final e in expenses) _record(e, currency, categoryLabel, walletLabel),
  ];

  static List<String> _record(
    ExpenseExportRow e,
    Currency currency,
    CategoryLabeler categoryLabel,
    WalletLabeler walletLabel,
  ) {
    final transfer = e.isTransfer;
    return [
      e.date.toIso(),
      if (transfer) 'transfer' else e.kind.name,
      e.title ?? '',
      e.amount.toDecimalString(currency.fractionDigits),
      currency.code,
      if (transfer) '' else categoryLabel(seedKey: e.categorySeedKey, name: e.categoryName),
      walletLabel(seedKey: e.walletSeedKey, name: e.walletName),
      if (transfer) walletLabel(seedKey: e.toWalletSeedKey, name: e.toWalletName) else '',
      e.note ?? '',
      if (e.isRecurring) 'Yes' else 'No',
    ];
  }
}
