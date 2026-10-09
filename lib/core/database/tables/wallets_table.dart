import 'package:drift/drift.dart';

/// The default wallet "Me" has a [seedKey] and gets its name from the
/// translation files; every other wallet has a user-typed [name]. Exactly one
/// of the two is set. Names are unique ignoring case.
@TableIndex(name: 'idx_wallets_sort_order', columns: {#sortOrder})
class WalletsTable extends Table {
  @override
  String get tableName => 'wallets';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get seedKey => text().nullable().unique()();

  /// 1–30 characters. A custom constraint, because `UNIQUE COLLATE NOCASE`
  /// has no Drift builder; it carries the length check with it.
  TextColumn get name =>
      text().nullable().customConstraint('UNIQUE COLLATE NOCASE CHECK (length(name) BETWEEN 1 AND 30)')();

  /// Key into the curated wallet icon registry.
  TextColumn get icon => text()();

  /// ARGB colour.
  IntColumn get color => integer()();
  IntColumn get sortOrder => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => ['CHECK ((seed_key IS NULL) <> (name IS NULL))'];
}
