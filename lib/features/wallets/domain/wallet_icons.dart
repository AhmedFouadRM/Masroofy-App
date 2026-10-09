/// Keys of the curated wallet icon set. The DB stores the key; presentation
/// maps it to `IconData` (see `shared/wallets/wallet_icon_registry.dart`, kept
/// in sync by a test).
abstract final class WalletIcons {
  static const fallback = 'person';

  static const List<String> keys = [fallback, 'woman', 'child', 'home', 'car', 'work', 'savings', 'school'];
}
