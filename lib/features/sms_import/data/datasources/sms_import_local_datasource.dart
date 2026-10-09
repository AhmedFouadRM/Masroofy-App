import 'package:drift/drift.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/database/tables/merchant_categories_table.dart';
import 'package:masroofy/core/database/tables/sms_imports_table.dart';
import 'package:masroofy/core/database/tables/trusted_senders_table.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';

part 'sms_import_local_datasource.g.dart';

/// Drift queries for SMS Import: its imports, the learned merchant
/// categories and the sender answers. Throws database errors; the repositories
/// map them to failures.
@DriftAccessor(
  tables: [SmsImportsTable, MerchantCategoriesTable, TrustedSendersTable, CategoriesTable, ExpensesTable],
)
class SmsImportLocalDatasource extends DatabaseAccessor<AppDatabase> with _$SmsImportLocalDatasourceMixin {
  SmsImportLocalDatasource(super.attachedDatabase);

  static const _converter = LocalDateConverter();

  // ── Imports ──

  Future<SmsImportsTableData?> findByKey(String smsKey) =>
      (select(smsImportsTable)..where((i) => i.smsKey.equals(smsKey))).getSingleOrNull();

  Future<Set<String>> existingKeys(Iterable<String> keys) async {
    final list = keys.toList();
    if (list.isEmpty) return {};
    final found = <String>{};
    // SQLite limits the number of variables in one statement.
    for (var start = 0; start < list.length; start += 500) {
      final chunk = list.sublist(start, (start + 500).clamp(0, list.length));
      final rows =
          await (selectOnly(smsImportsTable)
                ..addColumns([smsImportsTable.smsKey])
                ..where(smsImportsTable.smsKey.isIn(chunk)))
              .get();
      found.addAll(rows.map((row) => row.read(smsImportsTable.smsKey)!));
    }
    return found;
  }

  Future<SmsImportsTableData?> getById(int id) =>
      (select(smsImportsTable)..where((i) => i.id.equals(id))).getSingleOrNull();

  Future<SmsImportsTableData> insertImport(SmsImportsTableCompanion row) => into(smsImportsTable).insertReturning(row);

  /// Returns the number of rows changed.
  Future<int> updateImport(int id, SmsImportsTableCompanion row) =>
      (update(smsImportsTable)..where((i) => i.id.equals(id))).write(row);

  Future<List<SmsImportsTableData>> findCancellable({required int amountMinor, required DateTime since}) =>
      (select(smsImportsTable)
            ..where(
              (i) =>
                  i.amountMinor.equals(amountMinor) &
                  i.kind.equals(TransactionKind.expense.name) &
                  i.status.isIn(const ['added', 'pending']) &
                  i.receivedAt.isBiggerOrEqualValue(since),
            )
            ..orderBy([(i) => OrderingTerm.desc(i.receivedAt), (i) => OrderingTerm.desc(i.id)]))
          .get();

  Stream<List<SmsImportsTableData>> watchRecent({required DateTime since}) =>
      (select(smsImportsTable)
            ..where((i) => i.receivedAt.isBiggerOrEqualValue(since))
            ..orderBy([(i) => OrderingTerm.desc(i.receivedAt), (i) => OrderingTerm.desc(i.id)]))
          .watch();

  Future<int> deleteImport(int id) => (delete(smsImportsTable)..where((i) => i.id.equals(id))).go();

  Future<int> deleteAllImports() => delete(smsImportsTable).go();

  Future<Set<String>> importedSenders() async {
    final rows = await (selectOnly(smsImportsTable, distinct: true)..addColumns([smsImportsTable.sender])).get();
    return {for (final row in rows) row.read(smsImportsTable.sender)!};
  }

  /// Whether a transaction that was not generated from a template has
  /// [amountMinor] and [kind] on a date from [from] to [to].
  Future<bool> hasLookalike({
    required int amountMinor,
    required TransactionKind kind,
    required LocalDate from,
    required LocalDate to,
  }) async {
    final count = expensesTable.id.count();
    final query =
        selectOnly(expensesTable).join([
            innerJoin(categoriesTable, categoriesTable.id.equalsExp(expensesTable.categoryId)),
          ])
          ..addColumns([count])
          ..where(
            expensesTable.amountMinor.equals(amountMinor) &
                categoriesTable.kind.equals(kind.name) &
                expensesTable.source.isNotValue('recurring') &
                expensesTable.date.isBetweenValues(_converter.toSql(from), _converter.toSql(to)),
          );
    return ((await query.getSingle()).read(count) ?? 0) > 0;
  }

  // ── Senders ──

  Future<bool?> trustOf(String sender) async =>
      (await (select(trustedSendersTable)..where((t) => t.sender.equals(sender))).getSingleOrNull())?.trusted;

  Future<void> setTrusted(String sender, {required bool trusted}) => into(trustedSendersTable).insertOnConflictUpdate(
    TrustedSendersTableCompanion.insert(sender: sender, trusted: trusted),
  );

  Future<Map<String, bool>> trusted() async => {
    for (final row in await select(trustedSendersTable).get()) row.sender: row.trusted,
  };

  Stream<Map<String, bool>> watchTrust() =>
      select(trustedSendersTable).watch().map((rows) => {for (final row in rows) row.sender: row.trusted});

  // ── Learned categories ──

  /// The learned category of [merchantKey], when its kind is [kind].
  Future<int?> learnedCategory(String merchantKey, TransactionKind kind) async {
    final row =
        await (select(merchantCategoriesTable).join([
              innerJoin(categoriesTable, categoriesTable.id.equalsExp(merchantCategoriesTable.categoryId)),
            ])..where(
              merchantCategoriesTable.merchantKey.equals(merchantKey) & categoriesTable.kind.equals(kind.name),
            ))
            .getSingleOrNull();
    return row?.readTable(merchantCategoriesTable).categoryId;
  }

  Future<int?> categoryIdBySeedKey(String seedKey) async =>
      (await (select(categoriesTable)..where((c) => c.seedKey.equals(seedKey))).getSingleOrNull())?.id;

  Future<void> learn(String merchantKey, int categoryId) => into(merchantCategoriesTable).insertOnConflictUpdate(
    MerchantCategoriesTableCompanion.insert(
      merchantKey: merchantKey,
      categoryId: categoryId,
      updatedAt: Value(DateTime.now().toUtc()),
    ),
  );
}
