import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/data/datasources/wallet_local_datasource.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer_draft.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_transfer_repository.dart';

class TransferRepositoryImpl implements ITransferRepository {
  TransferRepositoryImpl(this._datasource);

  final WalletLocalDatasource _datasource;

  @override
  Future<Either<Failure, int>> create(TransferDraft draft) => guardDb(
    () => _datasource.insertTransfer(
      fromWalletId: draft.fromWalletId,
      toWalletId: draft.toWalletId,
      amountMinor: draft.amount.minor,
      date: draft.date,
      note: draft.note,
    ),
  );

  @override
  Future<Either<Failure, Unit>> update(int id, TransferDraft draft) async => (await guardDb(
    () => _datasource.updateTransfer(
      id,
      fromWalletId: draft.fromWalletId,
      toWalletId: draft.toWalletId,
      amountMinor: draft.amount.minor,
      date: draft.date,
      note: draft.note,
    ),
  )).flatMap((legs) => legs == 2 ? const Right(unit) : const Left(Failure.notFound()));
}
