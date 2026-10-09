import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';

part 'wallets_state.freezed.dart';

enum WalletsStatus { loading, loaded, failure }

@freezed
abstract class WalletsState with _$WalletsState {
  const factory WalletsState({
    @Default(WalletsStatus.loading) WalletsStatus status,

    /// Every wallet with its balance this month, in display order.
    @Default(<WalletSummary>[]) List<WalletSummary> wallets,

    /// Why loading failed (`status == failure`).
    Failure? loadFailure,
  }) = _WalletsState;
}
