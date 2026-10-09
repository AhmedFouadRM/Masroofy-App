import 'package:flutter/widgets.dart';
import 'package:masroofy/features/wallets/domain/wallet_icons.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Maps the stored icon keys ([WalletIcons.keys]) to Material Symbols Rounded
/// glyphs. Const, so unused glyphs are tree-shaken from the font.
abstract final class WalletIconRegistry {
  static const Map<String, IconData> icons = {
    'person': Symbols.person_rounded,
    'woman': Symbols.woman_rounded,
    'child': Symbols.child_care_rounded,
    'home': Symbols.home_rounded,
    'car': Symbols.directions_car_rounded,
    'work': Symbols.work_rounded,
    'savings': Symbols.savings_rounded,
    'school': Symbols.school_rounded,
  };

  /// Unknown keys (e.g. from a newer backup) fall back to `person`.
  static IconData of(String key) => icons[key] ?? icons[WalletIcons.fallback]!;
}
