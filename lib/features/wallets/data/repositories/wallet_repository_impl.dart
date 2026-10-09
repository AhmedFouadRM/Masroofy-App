import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/data/datasources/wallet_local_datasource.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_draft.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';

class WalletRepositoryImpl implements IWalletRepository {
  WalletRepositoryImpl(this._datasource);

  final WalletLocalDatasource _datasource;

  @override
  Stream<Either<Failure, List<WalletSummary>>> watchSummaries(DateRange range) =>
      _datasource.watchSummaries(range).map((rows) => rows.map(_toSummary).toList()).guarded();

  @override
  Future<Either<Failure, Wallet>> getById(int id) async => (await guardDb(() => _datasource.getById(id))).flatMap(
    (row) => row == null ? const Left(Failure.notFound()) : Right(_toWallet(row)),
  );

  @override
  Future<Either<Failure, List<String>>> customNames({int? excludeId}) =>
      guardDb(() => _datasource.customNames(excludeId: excludeId));

  @override
  Future<Either<Failure, int>> create(WalletDraft draft) =>
      guardDb(() => _datasource.insertWallet(name: draft.name!, icon: draft.icon, color: draft.color));

  @override
  Future<Either<Failure, Unit>> update(int id, WalletDraft draft) async => (await guardDb(
    () => _datasource.updateWallet(id, name: draft.name, icon: draft.icon, color: draft.color),
  )).flatMap((rows) => rows == 1 ? const Right(unit) : const Left(Failure.notFound()));

  @override
  Future<Either<Failure, Unit>> delete(int id, {int? moveTo}) async =>
      (await guardDb(() => _datasource.deleteWallet(id, moveTo: moveTo))).flatMap(
        (result) => switch (result) {
          WalletDeletion.deleted => const Right(unit),
          WalletDeletion.notFound => const Left(Failure.notFound()),
          WalletDeletion.lastWallet => const Left(
            ValidationFailure(field: 'wallet', reason: ValidationReason.lastWallet),
          ),
          WalletDeletion.needsMoveTarget => const Left(
            ValidationFailure(field: 'moveTo', reason: ValidationReason.required),
          ),
        },
      );

  static Wallet _toWallet(WalletsTableData row) => Wallet(
    id: row.id,
    seedKey: row.seedKey,
    name: row.name,
    icon: row.icon,
    color: row.color,
    sortOrder: row.sortOrder,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );

  static WalletSummary _toSummary(WalletSummaryRow row) => WalletSummary(
    wallet: _toWallet(row.wallet),
    balance: Money(row.balanceMinor),
    transactionCount: row.expenseCount,
    transferCount: row.transferCount,
    templateCount: row.recurringCount,
  );
}
