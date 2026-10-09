import 'dart:convert';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/domain/entities/backup_preview.dart';

/// Every row of the database, as read for a backup or ready to be restored.
class BackupSnapshot {
  const BackupSnapshot({
    required this.wallets,
    required this.categories,
    required this.recurring,
    required this.transfers,
    required this.expenses,
    required this.budgets,
    this.merchantCategories = const [],
    this.trustedSenders = const [],
  });

  final List<WalletsTableData> wallets;
  final List<CategoriesTableData> categories;
  final List<RecurringExpensesTableData> recurring;
  final List<TransfersTableData> transfers;
  final List<ExpensesTableData> expenses;
  final List<BudgetsTableData> budgets;

  /// SMS Import's learned categories and sender answers. Its import history
  /// is not part of a backup.
  final List<MerchantCategoriesTableData> merchantCategories;
  final List<TrustedSendersTableData> trustedSenders;
}

/// The preferences a backup carries. App Lock and the PIN are deliberately
/// absent: restoring a lock flag without its PIN would lock the user out.
class BackupPreferences {
  const BackupPreferences({
    required this.currencyCode,
    required this.themeMode,
    required this.westernDigits,
    required this.defaultWalletId,
  });

  final String currencyCode;
  final String themeMode;
  final bool westernDigits;

  /// The wallet new transactions go to when All wallets is viewed.
  final int defaultWalletId;
}

typedef DecodedBackup = ({BackupSnapshot snapshot, BackupPreferences preferences, DateTime exportedAt});

/// The versioned backup file (Settings PRD → Export Backup).
///
/// ```json
/// {"format":"masroofy-backup","version":4,"exportedAt":"…Z",
///  "preferences":{"currency_code":"EGP","theme_mode":"system","western_digits":false,"default_wallet_id":1},
///  "wallets":[…],"categories":[…],"recurringExpenses":[…],"transfers":[…],"expenses":[…],"budgets":[…],
///  "merchantCategories":[…],"trustedSenders":[…]}
/// ```
///
/// Version 2 adds each category's `kind` (`expense` or `income`); a version 1
/// file has none and every category is an expense category. Version 3 adds the
/// wallets, the default wallet, the transfers and each row's `walletId`,
/// `transferId` and `direction`; an older file restores into one wallet, "Me".
/// Version 4 adds SMS Import's learned merchant categories and trusted senders
/// (not its import history) and each expense's `source`; an older file has no
/// SMS data, and its rows from a template are `recurring`, the rest `manual`.
/// Amounts are integer minor units in the file's `currency_code`. [decode]
/// checks everything (types, ranges, references, uniqueness) and throws a
/// [FormatException] on the first problem, so nothing is written from a bad file.
abstract final class BackupCodec {
  static const format = 'masroofy-backup';
  static const version = 4;
  static const _sources = ['manual', 'sms', 'recurring'];

  static const _frequencies = ['daily', 'weekly', 'monthly', 'yearly'];
  static const _periods = ['weekly', 'monthly'];
  static const _kinds = ['expense', 'income'];
  static const _directions = ['out', 'in'];

  static String encode(BackupSnapshot snapshot, BackupPreferences preferences, {required DateTime exportedAt}) =>
      jsonEncode({
        'format': format,
        'version': version,
        'exportedAt': exportedAt.toUtc().toIso8601String(),
        'preferences': {
          'currency_code': preferences.currencyCode,
          'theme_mode': preferences.themeMode,
          'western_digits': preferences.westernDigits,
          'default_wallet_id': preferences.defaultWalletId,
        },
        'wallets': [
          for (final w in snapshot.wallets)
            {
              'id': w.id,
              'seedKey': w.seedKey,
              'name': w.name,
              'icon': w.icon,
              'color': w.color,
              'sortOrder': w.sortOrder,
              'createdAt': _time(w.createdAt),
              'updatedAt': _time(w.updatedAt),
            },
        ],
        'categories': [
          for (final c in snapshot.categories)
            {
              'id': c.id,
              'seedKey': c.seedKey,
              'name': c.name,
              'icon': c.icon,
              'color': c.color,
              'kind': c.kind,
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
              'walletId': r.walletId,
              'categoryId': r.categoryId,
              'frequency': r.frequency,
              'startDate': r.startDate.toIso(),
              'nextDueDate': r.nextDueDate.toIso(),
              'isActive': r.isActive,
              'createdAt': _time(r.createdAt),
              'updatedAt': _time(r.updatedAt),
            },
        ],
        'transfers': [
          for (final t in snapshot.transfers)
            {'id': t.id, 'createdAt': _time(t.createdAt), 'updatedAt': _time(t.updatedAt)},
        ],
        'expenses': [
          for (final e in snapshot.expenses)
            {
              'id': e.id,
              'title': e.title,
              'amountMinor': e.amountMinor,
              'walletId': e.walletId,
              'categoryId': e.categoryId,
              'date': e.date.toIso(),
              'note': e.note,
              'recurringExpenseId': e.recurringExpenseId,
              'occurrenceDate': e.occurrenceDate?.toIso(),
              'transferId': e.transferId,
              'direction': e.direction,
              'source': e.source,
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
        'merchantCategories': [
          for (final m in snapshot.merchantCategories)
            {'merchantKey': m.merchantKey, 'categoryId': m.categoryId, 'updatedAt': _time(m.updatedAt)},
        ],
        'trustedSenders': [
          for (final t in snapshot.trustedSenders)
            {'sender': t.sender, 'trusted': t.trusted, 'createdAt': _time(t.createdAt)},
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

    final exportedAt = DateTime.parse(_get<String>(root, 'exportedAt'));
    // A file before version 3 has no wallets: everything goes into "Me".
    final wallets = fileVersion < 3 ? [_meWallet(exportedAt)] : _list(root, 'wallets').map(_wallet).toList();
    final walletIds = _uniqueIds(wallets.map((w) => w.id), 'wallet');
    if (wallets.isEmpty) throw const FormatException('A backup needs a wallet');
    final seedKeys = wallets.map((w) => w.seedKey).whereType<String>().toList();
    if (seedKeys.toSet().length != seedKeys.length) throw const FormatException('Duplicate wallet seedKey');
    final names = wallets.map((w) => w.name?.toLowerCase()).whereType<String>().toList();
    if (names.toSet().length != names.length) throw const FormatException('Duplicate wallet name');
    final meId = wallets.first.id;

    final preferences = _preferences(
      _get<Map<String, dynamic>>(root, 'preferences'),
      fileVersion: fileVersion,
      walletIds: walletIds,
      meId: meId,
    );
    final categories = _list(root, 'categories').map((m) => _category(m, fileVersion: fileVersion)).toList();
    final categoryIds = _uniqueIds(categories.map((c) => c.id), 'category');
    final categorySeedKeys = categories.map((c) => c.seedKey).whereType<String>().toList();
    if (categorySeedKeys.toSet().length != categorySeedKeys.length) throw const FormatException('Duplicate seedKey');

    final recurring = _list(
      root,
      'recurringExpenses',
    ).map((m) => _recurring(m, categoryIds, walletIds, fileVersion: fileVersion, meId: meId)).toList();
    final recurringIds = _uniqueIds(recurring.map((r) => r.id), 'recurring');

    final transfers = fileVersion < 3 ? <TransfersTableData>[] : _list(root, 'transfers').map(_transfer).toList();
    final transferIds = _uniqueIds(transfers.map((t) => t.id), 'transfer');

    final expenses = _list(root, 'expenses')
        .map(
          (m) => _expense(
            m,
            categoryIds,
            recurringIds,
            walletIds,
            transferIds,
            fileVersion: fileVersion,
            meId: meId,
          ),
        )
        .toList();
    _uniqueIds(expenses.map((e) => e.id), 'expense');
    _checkTransferLegs(transferIds, expenses);
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

    // SMS Import data exists from version 4.
    final merchantCategories = fileVersion < 4
        ? <MerchantCategoriesTableData>[]
        : _list(root, 'merchantCategories').map((m) => _merchantCategory(m, categoryIds)).toList();
    if (merchantCategories.map((m) => m.merchantKey).toSet().length != merchantCategories.length) {
      throw const FormatException('Two categories for one merchant');
    }
    final trustedSenders = fileVersion < 4
        ? <TrustedSendersTableData>[]
        : _list(root, 'trustedSenders').map(_trustedSender).toList();
    if (trustedSenders.map((t) => t.sender).toSet().length != trustedSenders.length) {
      throw const FormatException('Two answers for one sender');
    }

    return (
      snapshot: BackupSnapshot(
        wallets: wallets,
        categories: categories,
        recurring: recurring,
        transfers: transfers,
        expenses: expenses,
        budgets: budgets,
        merchantCategories: merchantCategories,
        trustedSenders: trustedSenders,
      ),
      preferences: preferences,
      exportedAt: exportedAt,
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

  static BackupPreferences _preferences(
    Map<String, dynamic> map, {
    required int fileVersion,
    required Set<int> walletIds,
    required int meId,
  }) {
    final currencyCode = _get<String>(map, 'currency_code');
    final themeMode = _get<String>(map, 'theme_mode');
    if (CurrencyUtils.byCode(currencyCode) == null) throw const FormatException('Unknown currency');
    if (!ThemeMode.values.asNameMap().containsKey(themeMode)) throw const FormatException('Unknown theme');
    final defaultWalletId = fileVersion < 3 ? meId : _get<int>(map, 'default_wallet_id');
    if (!walletIds.contains(defaultWalletId)) throw const FormatException('Unknown default wallet');
    return BackupPreferences(
      currencyCode: currencyCode,
      themeMode: themeMode,
      westernDigits: _get<bool>(map, 'western_digits'),
      defaultWalletId: defaultWalletId,
    );
  }

  /// The one wallet a version 1 or 2 backup restores into.
  static WalletsTableData _meWallet(DateTime exportedAt) => WalletsTableData(
    id: 1,
    seedKey: DefaultWallets.meSeedKey,
    icon: DefaultWallets.meIcon,
    color: DefaultWallets.meColor,
    sortOrder: 0,
    createdAt: exportedAt,
    updatedAt: exportedAt,
  );

  static WalletsTableData _wallet(Map<String, dynamic> map) {
    final seedKey = _textOrNull(map, 'seedKey', max: 50);
    final name = _textOrNull(map, 'name', max: AppConstants.maxWalletNameLength);
    // Exactly one of the two (the table's CHECK constraint).
    if ((seedKey == null) == (name == null)) throw const FormatException('A wallet needs a seedKey or a name');
    return WalletsTableData(
      id: _get<int>(map, 'id'),
      seedKey: seedKey,
      name: name,
      icon: _text(map, 'icon', min: 1, max: 100),
      color: _get<int>(map, 'color'),
      sortOrder: _get<int>(map, 'sortOrder'),
      createdAt: _timestamp(map, 'createdAt'),
      updatedAt: _timestamp(map, 'updatedAt'),
    );
  }

  static TransfersTableData _transfer(Map<String, dynamic> map) => TransfersTableData(
    id: _get<int>(map, 'id'),
    createdAt: _timestamp(map, 'createdAt'),
    updatedAt: _timestamp(map, 'updatedAt'),
  );

  /// Every transfer is two legs: an out and an in, in two wallets, with one
  /// amount and one date.
  static void _checkTransferLegs(Set<int> transferIds, List<ExpensesTableData> expenses) {
    final legs = <int, List<ExpensesTableData>>{};
    for (final e in expenses) {
      if (e.transferId case final id?) (legs[id] ??= []).add(e);
    }
    for (final id in transferIds) {
      final pair = legs[id] ?? const <ExpensesTableData>[];
      if (pair.length != 2 || pair.map((e) => e.direction).toSet().length != 2) {
        throw const FormatException('A transfer needs an out leg and an in leg');
      }
      final [a, b] = pair;
      if (a.walletId == b.walletId || a.amountMinor != b.amountMinor || a.date != b.date) {
        throw const FormatException('The legs of a transfer disagree');
      }
    }
  }

  static CategoriesTableData _category(Map<String, dynamic> map, {required int fileVersion}) {
    final seedKey = _textOrNull(map, 'seedKey', max: 50);
    final name = _textOrNull(map, 'name', max: 50);
    // Exactly one of the two (the table's CHECK constraint).
    if ((seedKey == null) == (name == null)) throw const FormatException('A category needs a seedKey or a name');
    // Version 1 predates income: every category is an expense category.
    final kind = fileVersion < 2 ? 'expense' : _get<String>(map, 'kind');
    if (!_kinds.contains(kind)) throw const FormatException('Unknown category kind');
    return CategoriesTableData(
      id: _get<int>(map, 'id'),
      seedKey: seedKey,
      name: name,
      icon: _text(map, 'icon', min: 1, max: 100),
      color: _get<int>(map, 'color'),
      kind: kind,
      sortOrder: _get<int>(map, 'sortOrder'),
      isHidden: _get<bool>(map, 'isHidden'),
      createdAt: _timestamp(map, 'createdAt'),
      updatedAt: _timestamp(map, 'updatedAt'),
    );
  }

  static RecurringExpensesTableData _recurring(
    Map<String, dynamic> map,
    Set<int> categoryIds,
    Set<int> walletIds, {
    required int fileVersion,
    required int meId,
  }) {
    final categoryId = _get<int>(map, 'categoryId');
    final walletId = fileVersion < 3 ? meId : _get<int>(map, 'walletId');
    final frequency = _get<String>(map, 'frequency');
    if (!categoryIds.contains(categoryId)) throw const FormatException('Unknown category');
    if (!walletIds.contains(walletId)) throw const FormatException('Unknown wallet');
    if (!_frequencies.contains(frequency)) throw const FormatException('Unknown frequency');
    return RecurringExpensesTableData(
      id: _get<int>(map, 'id'),
      title: _text(map, 'title', min: 1, max: 100),
      amountMinor: _positive(map, 'amountMinor'),
      walletId: walletId,
      categoryId: categoryId,
      frequency: frequency,
      startDate: _date(map, 'startDate'),
      nextDueDate: _date(map, 'nextDueDate'),
      isActive: _get<bool>(map, 'isActive'),
      createdAt: _timestamp(map, 'createdAt'),
      updatedAt: _timestamp(map, 'updatedAt'),
    );
  }

  static ExpensesTableData _expense(
    Map<String, dynamic> map,
    Set<int> categoryIds,
    Set<int> recurringIds,
    Set<int> walletIds,
    Set<int> transferIds, {
    required int fileVersion,
    required int meId,
  }) {
    final categoryId = _getOrNull<int>(map, 'categoryId');
    final recurringId = _getOrNull<int>(map, 'recurringExpenseId');
    final walletId = fileVersion < 3 ? meId : _get<int>(map, 'walletId');
    final transferId = fileVersion < 3 ? null : _getOrNull<int>(map, 'transferId');
    final direction = fileVersion < 3 ? null : _getOrNull<String>(map, 'direction');
    if (!walletIds.contains(walletId)) throw const FormatException('Unknown wallet');
    if (recurringId != null && !recurringIds.contains(recurringId)) {
      throw const FormatException('Unknown recurring template');
    }
    // A category on every row except transfer legs, and a direction on legs only
    // (the table's CHECK constraints).
    // Before version 4 there was no source: a row from a template is `recurring`.
    final source = fileVersion < 4
        ? (recurringId != null || map['occurrenceDate'] != null ? 'recurring' : 'manual')
        : _get<String>(map, 'source');
    if (!_sources.contains(source)) throw const FormatException('Unknown source');
    if (transferId == null) {
      if (categoryId == null || !categoryIds.contains(categoryId)) throw const FormatException('Unknown category');
      if (direction != null) throw const FormatException('Only a transfer leg has a direction');
    } else {
      if (!transferIds.contains(transferId)) throw const FormatException('Unknown transfer');
      if (categoryId != null) throw const FormatException('A transfer leg has no category');
      if (!_directions.contains(direction)) throw const FormatException('Unknown direction');
    }
    return ExpensesTableData(
      id: _get<int>(map, 'id'),
      title: _textOrNull(map, 'title', max: 100),
      amountMinor: _positive(map, 'amountMinor'),
      walletId: walletId,
      categoryId: categoryId,
      date: _date(map, 'date'),
      note: _textOrNull(map, 'note', max: 500, allowEmpty: true),
      recurringExpenseId: recurringId,
      occurrenceDate: _dateOrNull(map, 'occurrenceDate'),
      transferId: transferId,
      direction: direction,
      source: source,
      createdAt: _timestamp(map, 'createdAt'),
      updatedAt: _timestamp(map, 'updatedAt'),
    );
  }

  static MerchantCategoriesTableData _merchantCategory(Map<String, dynamic> map, Set<int> categoryIds) {
    final categoryId = _get<int>(map, 'categoryId');
    if (!categoryIds.contains(categoryId)) throw const FormatException('Unknown category');
    return MerchantCategoriesTableData(
      merchantKey: _text(map, 'merchantKey', min: 1, max: 200),
      categoryId: categoryId,
      updatedAt: _timestamp(map, 'updatedAt'),
    );
  }

  static TrustedSendersTableData _trustedSender(Map<String, dynamic> map) => TrustedSendersTableData(
    sender: _text(map, 'sender', min: 1, max: 100),
    trusted: _get<bool>(map, 'trusted'),
    createdAt: _timestamp(map, 'createdAt'),
  );

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
