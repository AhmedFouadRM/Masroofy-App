import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/wallets/domain/wallet_icons.dart';
import 'package:masroofy/shared/wallets/wallet_icon_registry.dart';

void main() {
  test('every icon key has a glyph, and every glyph a key', () {
    expect(WalletIconRegistry.icons.keys.toSet(), WalletIcons.keys.toSet());
    expect(WalletIcons.keys, hasLength(8));
  });

  test('the default wallet uses a registered icon', () {
    expect(WalletIcons.keys, contains(DefaultWallets.meIcon));
  });

  test('unknown keys fall back to person', () {
    expect(WalletIconRegistry.of('nope'), WalletIconRegistry.icons['person']);
    expect(WalletIcons.fallback, 'person');
  });
}
