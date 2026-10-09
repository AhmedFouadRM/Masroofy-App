import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';

/// The imports SMS Import has made, and the senders the user answered for.
abstract interface class ISmsImportRepository {
  /// The import made from the message with [smsKey], if any.
  Future<Either<Failure, SmsImport?>> findByKey(String smsKey);

  /// Those of [keys] that were already imported, in any status.
  Future<Either<Failure, Set<String>>> existingKeys(Iterable<String> keys);

  /// Fails with `NotFoundFailure` when the import is gone.
  Future<Either<Failure, SmsImport>> getById(int id);

  /// Fails with `ConstraintFailure` when an import with this key exists.
  Future<Either<Failure, SmsImport>> insert(SmsImportDraft draft);

  /// Sets the status; [expenseId] links the transaction an `added` import
  /// became.
  Future<Either<Failure, Unit>> setStatus(int id, SmsImportStatus status, {int? expenseId});

  /// Imports of this [amount] received since [since] that can still be
  /// cancelled: `added` or `pending` expenses. Newest first.
  Future<Either<Failure, List<SmsImport>>> findCancellable({required Money amount, required DateTime since});

  /// Imports received since [since], newest first.
  Stream<Either<Failure, List<SmsImport>>> watchRecent({required DateTime since});

  /// Deletes one import row (an import that could not be completed).
  Future<Either<Failure, Unit>> deleteImport(int id);

  /// Deletes every import row; the transactions stay.
  Future<Either<Failure, Unit>> deleteHistory();

  /// The user's answer for a sender (see `SenderCatalog.keyOf`), or null when
  /// never asked.
  Future<Either<Failure, bool?>> trustOf(String senderKey);

  Future<Either<Failure, Unit>> setTrusted(String senderKey, {required bool trusted});

  /// Every answer, by sender key.
  Future<Either<Failure, Map<String, bool>>> trusted();

  Stream<Either<Failure, Map<String, bool>>> watchTrust();

  /// The addresses that have imports.
  Future<Either<Failure, Set<String>>> importedSenders();

  /// Whether a transaction that was not generated from a template has this
  /// amount and kind on a date from [from] to [to].
  Future<Either<Failure, bool>> hasLookalike({
    required Money amount,
    required TransactionKind kind,
    required LocalDate from,
    required LocalDate to,
  });
}
