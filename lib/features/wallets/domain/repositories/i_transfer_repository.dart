import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer_draft.dart';

abstract interface class ITransferRepository {
  /// Writes the two legs (out of the source wallet, into the target) in one
  /// transaction. Returns the transfer id.
  Future<Either<Failure, int>> create(TransferDraft draft);

  /// Updates both legs and the transfer in one transaction.
  Future<Either<Failure, Unit>> update(int id, TransferDraft draft);
}
