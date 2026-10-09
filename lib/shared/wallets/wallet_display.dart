import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show Bidi;
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';

extension WalletDisplay on Wallet {
  /// Localized name for the seeded "Me" (via `seed_key`), the typed name for
  /// the others. Reads the current locale, so call it inside `build`.
  String get displayName => isSeeded ? StringManager.walletName(seedKey!) : name!;

  /// A typed name is user text, so it takes the direction of its own content
  /// (an Arabic name inside the English UI and the other way round). The
  /// seeded name follows the UI language.
  TextDirection? get nameDirection =>
      isSeeded ? null : (Bidi.detectRtlDirectionality(name!) ? TextDirection.rtl : TextDirection.ltr);
}
