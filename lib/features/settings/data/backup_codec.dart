import 'dart:convert';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/domain/entities/backup_preview.dart';

/// Every row of the database, as read for a backup or ready to be restored.
class BackupSnapshot {
  const BackupSnapshot({
    required this.categories,
    required this.recurring,
    required this.expenses,
    required this.budgets,
  });

  final List<CategoriesTableData> categories;
  final List<RecurringExpensesTableData> recurring;
  final List<ExpensesTableData> expenses;
  final List<BudgetsTableData> budgets;
}

/// The preferences a backup carries. App Lock and the PIN are deliberately
/// absent: restoring a lock flag without its PIN would lock the user out.
class BackupPreferences {
  const BackupPreferences({required this.currencyCode, required this.themeMode, required this.westernDigits});

  final String currencyCode;
  final String themeMode;
  final bool westernDigits;
}

typedef DecodedBackup = ({BackupSnapshot snapshot, BackupPreferences preferences, DateTime exportedAt});

/// The versioned backup file (Settings PRD → Export Backup).
///
/// ```json
/// {"format":"masroofy-backup","version":1,"exportedAt":"…Z",
///  "preferences":{"currency_code":"EGP","theme_mode":"system","western_digits":false},
///  "categories":[…],"recurringExpenses":[…],"expenses":[…],"budgets":[…]}
/// ```
///
/// Amounts are integer minor units in the file's `currency_code`. [decode]
/// checks everything (types, ranges, references, uniqueness) and throws a
/// [FormatException] on the first problem, so nothing is written from a bad file.
abstract final class BackupCodec {
  static const format = 'masroofy-backup';
  static const version = 1;

  static const _frequencies = ['daily', 'weekly', 'monthly', 'yearly'];
  static const _periods = ['weekly', 'monthly'];

  static String encode(BackupSnapshot snapshot, BackupPreferences preferences, {required DateTime exportedAt}) =>
      jsonEncode({
        'format': format,
        'version': version,
        'exportedAt': exportedAt.toUtc().toIso8601String(),
        'preferences': {
          'currency_code': preferences.currencyCode,
          'theme_mode': preferences.themeMode,
          'western_digits': preferences.westernDigits,
        },
        'categories': [
          for (final c in snapshot.categories)
            {
              'id': c.id,
              'seedKey': c.seedKey,
              'name': c.name,
              'icon': c.icon,
              'color': c.color,
              'sortOrder': c.sortOrder,
              'isHidden': c.isHidden,
              'createdAt': _time(c.createdAt),
              'updatedAt': _time(c.updatedAt),
            },
        ],
        'recurringExpenses': [
          for (final r in snapshot.recurring)
            {
              'id': r.id,
              'title': r.title,
              'amountMinor': r.amountMinor,
              'categoryId': r.categoryId,
              'frequency': r.frequency,
              'startDate': r.startDate.toIso(),
              'nextDueDate': r.nextDueDate.toIso(),
              'isActive': r.isActive,
              'createdAt': _time(r.createdAt),
              'updatedAt': _time(r.updatedAt),
            },
        ],
        'expenses': [
          for (final e in snapshot.expenses)
            {
              'id': e.id,
              'title': e.title,
              'amountMinor': e.amountMinor,
              'categoryId': e.categoryId,
              'date': e.date.toIso(),
              'note': e.note,
              'recurringExpenseId': e.recurringExpenseId,
              'occurrenceDate': e.occurrenceDate?.toIso(),
              'createdAt': _time(e.createdAt),
              'updatedAt': _time(e.updatedAt),
            },
        ],
        'budgets': [
          for (final b in snapshot.budgets)
            {
              'id': b.id,
              'categoryId': b.categoryId,
              'limitMinor': b.limitMinor,
              'period': b.period,
              'lastAlertedPeriodStart': b.lastAlertedPeriodStart?.toIso(),
              'createdAt': _time(b.createdAt),
              'updatedAt': _time(b.updatedAt),
            },
        ],
      });

  static String _time(DateTime time) => time.toUtc().toIso8601String();

  /// Parses and fully validates [json]. Throws [FormatException] when it is
  /// not a usable backup of this app and a supported version.
  static DecodedBackup decode(String json) {
    final Object? root;
    try {
      root = jsonDecode(json);
    } on FormatException {
      throw const FormatException('Not JSON');
    }
    if (root is! Map<String, dynamic>) throw const FormatException('Not an object');
    if (root['format'] != format) throw const FormatException('Not a Masroofy backup');
    final fileVersion = root['version'];
    if (fileVersion is! int || fileVersion < 1 || fileVersion > version) {
      throw const FormatException('Unsupported version');
    }

    final preferences = _preferences(_get<Map<String, dynamic>>(root, 'preferences'));
    final categories = _list(root, 'categories').map(_category).toList();
    final categoryIds = _uniqueIds(categories.map((c) => c.id), 'category');
    final seedKeys = categories.map((c) => c.seedKey).whereType<String>().toList();
    if (seedKeys.toSet().length != seedKeys.length) throw const FormatException('Duplicate seedKey');

    final recurring = _list(root, 'recurringExpenses').map((m) => _recurring(m, categoryIds)).toList();
    final recurringIds = _uniqueIds(recurring.map((r) => r.id), 'recurring');

    final expenses = _list(root, 'expenses').map((m) => _expense(m, categoryIds, recurringIds)).toList();
    _uniqueIds(expenses.map((e) => e.id), 'expense');
    final occurrences = {
      for (final e in expenses)
        if (e.recurringExpenseId != null) (e.recurringExpenseId, e.occurrenceDate),
    };
    if (occurrences.length != expenses.where((e) => e.recurringExpenseId != null).length) {
      throw const FormatException('Duplicate occurrence');
    }

    final budgets = _list(root, 'budgets').map((m) => _budget(m, categoryIds)).toList();
    _uniqueIds(budgets.map((b) => b.id), 'budget');
    if (budgets.map((b) => b.categoryId).toSet().length != budgets.length) {
      throw const FormatException('Two budgets for one category');
    }

    return (
      snapshot: BackupSnapshot(categories: categories, recurring: recurring, expenses: expenses, budgets: budgets),
      preferences: preferences,
      exportedAt: DateTime.parse(_get<String>(root, 'exportedAt')),
    );
  }

  static BackupPreview preview(DecodedBackup backup) => BackupPreview(
    exportedAt: backup.exportedAt,
    expenses: backup.snapshot.expenses.length,
    categories: backup.snapshot.categories.length,
    budgets: backup.snapshot.budgets.length,
    recurring: backup.snapshot.recurring.length,
  );

  // ── Field readers: each throws a FormatException naming the bad key ──

  static T _get<T>(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is! T) throw FormatException('"$key" is missing or has the wrong type');
    return value;
  }

  static T? _getOrNull<T>(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value == null) return null;
    if (value is! T) throw FormatException('"$key" has the wrong type');
    return value;
  }

  static List<Map<String, dynamic>> _list(Map<String, dynamic> root, String key) {
    final list = _get<List<dynamic>>(root, key);
    return [
      for (final item in list)
        if (item is Map<String, dynamic>) item else throw FormatException('"$key" holds a non-object'),
    ];
  }

  static String _text(Map<String, dynamic> map, String key, {required int min, required int max}) {
    final value = _get<String>(map, key);
    if (value.length < min || value.length > max) throw FormatException('"$key" has an invalid length');
    return value;
  }

  static String? _textOrNull(Map<String, dynamic> map, String key, {required int max, bool allowEmpty = false}) {
    final value = _getOrNull<String>(map, key);
    if (value != null && ((value.isEmpty && !allowEmpty) || value.length > max)) {
      throw FormatException('"$key" has an invalid length');
    }
    return value;
  }

  static int _positive(Map<String, dynamic> map, String key) {
    final value = _get<int>(map, key);
    if (value <= 0) throw FormatException('"$key" must be positive');
    return value;
  }

  static LocalDate _date(Map<String, dynamic> map, String key) => LocalDate.parse(_get<String>(map, key));

  static LocalDate? _dateOrNull(Map<String, dynamic> map, String key) {
    final value = _getOrNull<String>(map, key);
    return value == null ? null : LocalDate.parse(value);
  }

  static DateTime _timestamp(Map<String, dynamic> map, String key) => DateTime.parse(_get<String>(map, key));

  static Set<int> _uniqueIds(Iterable<int> ids, String what) {
    final set = ids.toSet();
    if (set.length != ids.length || set.any((id) => id <= 0)) throw FormatException('Invalid $what ids');
    return set;
  }

  // ── Rows ──

  static BackupPreferences _preferences(Map<String, dynamic> map) {
    final currencyCode = _get<String>(map, 'currency_code');
    final themeMode = _get<String>(map, 'theme_mode');
    if (CurrencyUtils.byCode(currencyCode) == null) throw const FormatException('Unknown currency');
    if (!ThemeMode.values.asNameMap().containsKey(themeMode)) throw const FormatException('Unknown theme');
    return BackupPreferences(
      currencyCode: currencyCode,
      themeMode: themeMode,
      westernDigits: _get<bool>(map, 'western_digits'),
    );
  }

  static CategoriesTableData _category(Map<String, dynamic> map) {
    final seedKey = _textOrNull(map, 'seedKey', max: 50);
    final name = _textOrNull(map, 'name', max: 50);
    // Exactly one of the two (the table's CHECK constraint).
    if ((seedKey == null) == (name == null)) throw const FormatException('A category needs a seedKey or a name');
    return CategoriesTableData(
      id: _get<int>(map, 'id'),
      seedKey: seedKey,
      name: name,
      icon: _text(map, 'icon', min: 1, max: 100),
      color: _get<int>(map, 'color'),
      sortOrder: _get<int>(map, 'sortOrder'),
      isHidden: _get<bool>(map, 'isHidden'),
      createdAt: _timestamp(map, 'createdAt'),
      updatedAt: _timestamp(map, 'updatedAt'),
    );
  }

  static RecurringExpensesTableData _recurring(Map<String, dynamic> map, Set<int> categoryIds) {
    final categoryId = _get<int>(map, 'categoryId');
    final frequency = _get<String>(map, 'frequency');
    if (!categoryIds.contains(categoryId)) throw const FormatException('Unknown category');
    if (!_frequencies.contains(frequency)) throw const FormatException('Unknown frequency');
    return RecurringExpensesTableData(
      id: _get<int>(map, 'id'),
      title: _text(map, 'title', min: 1, max: 100),
      amountMinor: _positive(map, 'amountMinor'),
      categoryId: categoryId,
      frequency: frequency,
      startDate: _date(map, 'startDate'),
      nextDueDate: _date(map, 'nextDueDate'),
      isActive: _get<bool>(map, 'isActive'),
      createdAt: _timestamp(map, 'createdAt'),
      updatedAt: _timestamp(map, 'updatedAt'),
    );
  }

  static ExpensesTableData _expense(Map<String, dynamic> map, Set<int> categoryIds, Set<int> recurringIds) {
    final categoryId = _get<int>(map, 'categoryId');
    final recurringId = _getOrNull<int>(map, 'recurringExpenseId');
    if (!categoryIds.contains(categoryId)) throw const FormatException('Unknown category');
    if (recurringId != null && !recurringIds.contains(recurringId)) {
      throw const FormatException('Unknown recurring template');
    }
    return ExpensesTableData(
      id: _get<int>(map, 'id'),
      title: _textOrNull(map, 'title', max: 100),
      amountMinor: _positive(map, 'amountMinor'),
      categoryId: categoryId,
      date: _date(map, 'date'),
      note: _textOrNull(map, 'note', max: 500, allowEmpty: true),
      recurringExpenseId: recurringId,
      occurrenceDate: _dateOrNull(map, 'occurrenceDate'),
      createdAt: _timestamp(map, 'createdAt'),
      updatedAt: _timestamp(map, 'updatedAt'),
    );
  }

  static BudgetsTableData _budget(Map<String, dynamic> map, Set<int> categoryIds) {
    final categoryId = _get<int>(map, 'categoryId');
    final period = _get<String>(map, 'period');
    if (!categoryIds.contains(categoryId)) throw const FormatException('Unknown category');
    if (!_periods.contains(period)) throw const FormatException('Unknown period');
    return BudgetsTableData(
      id: _get<int>(map, 'id'),
      categoryId: categoryId,
      limitMinor: _positive(map, 'limitMinor'),
      period: period,
      lastAlertedPeriodStart: _dateOrNull(map, 'lastAlertedPeriodStart'),
      createdAt: _timestamp(map, 'createdAt'),
      updatedAt: _timestamp(map, 'updatedAt'),
    );
  }
}
