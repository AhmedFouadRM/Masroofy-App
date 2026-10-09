import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer_draft.dart';

/// Field rules from the Wallets PRD → Validation Rules.
abstract final class TransferValidator {
  /// Returns the first failing rule, or `null` when [transfer] is valid.
  /// [today] is the device-local date (injectable for tests).
  static ValidationFailure? validate(TransferDraft transfer, {required LocalDate today}) {
    if (transfer.fromWalletId <= 0) {
      return const ValidationFailure(field: 'fromWallet', reason: ValidationReason.required);
    }
    if (transfer.toWalletId <= 0) {
      return const ValidationFailure(field: 'toWallet', reason: ValidationReason.required);
    }
    if (transfer.fromWalletId == transfer.toWalletId) {
      return const ValidationFailure(field: 'toWallet', reason: ValidationReason.sameWallet);
    }
    if (!transfer.amount.isPositive) {
      return const ValidationFailure(field: 'amount', reason: ValidationReason.mustBePositive);
    }
    if (transfer.date.isAfter(today)) {
      return const ValidationFailure(field: 'date', reason: ValidationReason.inFuture);
    }
    final note = transfer.note;
    if (note != null && note.length > AppConstants.maxNoteLength) {
      return const ValidationFailure(field: 'note', reason: ValidationReason.tooLong);
    }
    return null;
  }
}
