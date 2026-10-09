/// Which wallet a new transaction starts in (Wallets PRD → flow step 8).
abstract final class WalletPreselect {
  /// The wallet being viewed, or the default wallet when viewing All wallets
  /// (a null [viewedWalletId]). Null only until a default has been chosen.
  static int? initial({required int? viewedWalletId, required int? defaultWalletId}) =>
      viewedWalletId ?? defaultWalletId;

  /// [preferred] when it is one of [walletIds]; otherwise the first wallet.
  /// Null when there are no wallets.
  static int? validated(int? preferred, List<int> walletIds) =>
      preferred != null && walletIds.contains(preferred) ? preferred : walletIds.firstOrNull;
}
