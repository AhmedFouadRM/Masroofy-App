import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_merchant_category_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';

/// What the user does with an import, from the notification actions, the
/// pre-filled form and the Trusted senders list.
class SmsImportActions {
  SmsImportActions(this._imports, this._merchantCategories);

  final ISmsImportRepository _imports;
  final IMerchantCategoryRepository _merchantCategories;

  /// "Ignore": no transaction is made from a pending import. An import that
  /// already became a transaction stays as it is.
  Future<Either<Failure, Unit>> ignore(int importId) async => switch (await _imports.getById(importId)) {
    Left(:final value) => Left(value),
    Right(:final value) when value.status != SmsImportStatus.pending => const Right(unit),
    Right() => await _imports.setStatus(importId, SmsImportStatus.ignored),
  };

  /// The form saved the transaction of a pending or ignored import: it is now
  /// `added`, and the merchant's category is remembered, so the next message
  /// from it uses what the user chose.
  Future<Either<Failure, Unit>> complete(int importId, {required int expenseId, required int categoryId}) async {
    final fetched = await _imports.getById(importId);
    if (fetched case Left(:final value)) return Left(value);
    final updated = await _imports.setStatus(importId, SmsImportStatus.added, expenseId: expenseId);
    if (updated.isLeft()) return updated;
    final key = fetched.toNullable()?.merchantKey;
    return key == null ? const Right(unit) : _merchantCategories.learn(key, categoryId);
  }

  /// Trusts or blocks [sender] for good. Trusting does not import the message
  /// that prompted it: the caller shows its notification.
  Future<Either<Failure, Unit>> setSenderTrusted(String sender, {required bool trusted}) =>
      _imports.setTrusted(SenderCatalog.keyOf(sender), trusted: trusted);

  /// Clears the import history; transactions stay.
  Future<Either<Failure, Unit>> deleteHistory() => _imports.deleteHistory();
}
