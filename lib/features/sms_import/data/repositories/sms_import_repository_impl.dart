import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/data/datasources/sms_import_local_datasource.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_merchant_category_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';

class SmsImportRepositoryImpl implements ISmsImportRepository, IMerchantCategoryRepository {
  SmsImportRepositoryImpl(this._datasource);

  final SmsImportLocalDatasource _datasource;

  @override
  Future<Either<Failure, SmsImport?>> findByKey(String smsKey) => guardDb(() async {
    final row = await _datasource.findByKey(smsKey);
    return row == null ? null : _toImport(row);
  });

  @override
  Future<Either<Failure, Set<String>>> existingKeys(Iterable<String> keys) =>
      guardDb(() => _datasource.existingKeys(keys));

  @override
  Future<Either<Failure, SmsImport>> getById(int id) async => (await guardDb(() => _datasource.getById(id))).flatMap(
    (row) => row == null ? const Left(Failure.notFound()) : Right(_toImport(row)),
  );

  @override
  Future<Either<Failure, SmsImport>> insert(SmsImportDraft draft) => guardDb(
    () async => _toImport(
      await _datasource.insertImport(
        SmsImportsTableCompanion.insert(
          smsKey: draft.smsKey,
          sender: draft.sender,
          receivedAt: draft.receivedAt,
          kind: draft.kind.name,
          amountMinor: draft.amount.minor,
          currency: draft.currency,
          date: draft.date,
          status: draft.status.name,
          merchant: Value(draft.merchant),
          categoryId: Value(draft.categoryId),
          cardLast4: Value(draft.cardLast4),
          note: Value(draft.note),
          expenseId: Value(draft.expenseId),
        ),
      ),
    ),
  );

  @override
  Future<Either<Failure, Unit>> setStatus(int id, SmsImportStatus status, {int? expenseId}) async => (await guardDb(
    () => _datasource.updateImport(
      id,
      SmsImportsTableCompanion(
        status: Value(status.name),
        expenseId: expenseId == null ? const Value.absent() : Value(expenseId),
      ),
    ),
  )).flatMap((rows) => rows == 1 ? const Right(unit) : const Left(Failure.notFound()));

  @override
  Future<Either<Failure, List<SmsImport>>> findCancellable({required Money amount, required DateTime since}) => guardDb(
    () async => [
      for (final row in await _datasource.findCancellable(amountMinor: amount.minor, since: since)) _toImport(row),
    ],
  );

  @override
  Stream<Either<Failure, List<SmsImport>>> watchRecent({required DateTime since}) =>
      _datasource.watchRecent(since: since).map((rows) => rows.map(_toImport).toList()).guarded();

  @override
  Future<Either<Failure, Unit>> deleteImport(int id) => guardDb(() async {
    await _datasource.deleteImport(id);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> deleteHistory() => guardDb(() async {
    await _datasource.deleteAllImports();
    return unit;
  });

  @override
  Future<Either<Failure, bool?>> trustOf(String senderKey) => guardDb(() => _datasource.trustOf(senderKey));

  @override
  Future<Either<Failure, Unit>> setTrusted(String senderKey, {required bool trusted}) => guardDb(() async {
    await _datasource.setTrusted(senderKey, trusted: trusted);
    return unit;
  });

  @override
  Future<Either<Failure, Map<String, bool>>> trusted() => guardDb(_datasource.trusted);

  @override
  Stream<Either<Failure, Map<String, bool>>> watchTrust() => _datasource.watchTrust().guarded();

  @override
  Future<Either<Failure, Set<String>>> importedSenders() => guardDb(_datasource.importedSenders);

  @override
  Future<Either<Failure, bool>> hasLookalike({
    required Money amount,
    required TransactionKind kind,
    required LocalDate from,
    required LocalDate to,
  }) => guardDb(() => _datasource.hasLookalike(amountMinor: amount.minor, kind: kind, from: from, to: to));

  // ── Learned categories ──

  @override
  Future<Either<Failure, int?>> learnedCategory(String merchantKey, TransactionKind kind) =>
      guardDb(() => _datasource.learnedCategory(merchantKey, kind));

  @override
  Future<Either<Failure, int?>> categoryIdBySeedKey(String seedKey) =>
      guardDb(() => _datasource.categoryIdBySeedKey(seedKey));

  @override
  Future<Either<Failure, Unit>> learn(String merchantKey, int categoryId) => guardDb(() async {
    await _datasource.learn(merchantKey, categoryId);
    return unit;
  });

  static SmsImport _toImport(SmsImportsTableData row) => SmsImport(
    id: row.id,
    smsKey: row.smsKey,
    sender: row.sender,
    receivedAt: row.receivedAt,
    kind: TransactionKind.values.byName(row.kind),
    amount: Money(row.amountMinor),
    currency: row.currency,
    date: row.date,
    status: SmsImportStatus.parse(row.status),
    merchant: row.merchant,
    categoryId: row.categoryId,
    cardLast4: row.cardLast4,
    note: row.note,
    expenseId: row.expenseId,
  );
}
