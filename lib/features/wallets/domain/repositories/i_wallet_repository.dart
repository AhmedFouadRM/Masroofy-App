import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_draft.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';

/// Wallets. Which one is the default and which one is viewed are preferences
/// (`SettingsCubit`), not data.
abstract interface class IWalletRepository {
  /// Every wallet in display order (by `sort_order`), each with its balance
  /// over [range] (income and transfers in, minus spending and transfers out)
  /// and its usage counts. Re-emits after any change to wallets or rows.
  Stream<Either<Failure, List<WalletSummary>>> watchSummaries(DateRange range);

  Future<Either<Failure, Wallet>> getById(int id);

  /// Names of the custom wallets, except [excludeId] (the one being edited).
  Future<Either<Failure, List<String>>> customNames({int? excludeId});

  /// Appends a wallet after the existing ones. Returns its id.
  Future<Either<Failure, int>> create(WalletDraft draft);

  /// A [WalletDraft.name] of null keeps a seeded wallet's name; a name
  /// replaces the seed key.
  Future<Either<Failure, Unit>> update(int id, WalletDraft draft);

  /// In one transaction: turns the transfers that touch the wallet into
  /// ordinary rows (an expense in Other or income in Other income, each in
  /// its own wallet), moves the wallet's rows and templates to [moveTo], then
  /// deletes it. Fails with `ValidationFailure(wallet, lastWallet)` for the
  /// only wallet, and with `ValidationFailure(moveTo, required)` when the
  /// wallet has rows or templates and no [moveTo].
  Future<Either<Failure, Unit>> delete(int id, {int? moveTo});
}
