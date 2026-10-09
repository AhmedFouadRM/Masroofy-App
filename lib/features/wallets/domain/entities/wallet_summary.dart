import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';

part 'wallet_summary.freezed.dart';

/// A wallet with its balance for a period and what references it: drives the
/// Wallets screen, the switcher sheet and the delete dialog.
@freezed
abstract class WalletSummary with _$WalletSummary {
  const factory WalletSummary({
    required Wallet wallet,

    /// Income and transfers in, minus spending and transfers out.
    required Money balance,

    /// Rows of the wallet, transfer legs included.
    required int transactionCount,

    /// How many of those rows are transfer legs.
    required int transferCount,
    required int templateCount,
  }) = _WalletSummary;

  const WalletSummary._();

  bool get isInUse => transactionCount > 0 || templateCount > 0;
}
