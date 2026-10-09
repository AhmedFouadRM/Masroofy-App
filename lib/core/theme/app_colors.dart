import 'package:flutter/material.dart';

/// Colours that are the same in light and dark mode. Everything else is a
/// semantic token in `MasroofyColors`.
abstract final class AppColors {
  // Category colours (Design_System.md → Category colours). Seeded into the
  // categories table and offered by the colour picker.
  static const Color categoryFood = Color(0xFFF97316);
  static const Color categoryTransport = Color(0xFF3B82F6);
  static const Color categoryShopping = Color(0xFFA855F7);
  static const Color categoryBills = Color(0xFFF59E0B);
  static const Color categoryHealth = Color(0xFFEF4444);
  static const Color categoryEntertainment = Color(0xFF06B6D4);
  static const Color categoryEducation = Color(0xFF6366F1);
  static const Color categoryOther = Color(0xFF64748B);

  static const Color walletEmerald = Color(0xFF059669);

  static const List<Color> categoryPalette = [
    categoryFood,
    categoryTransport,
    categoryShopping,
    categoryBills,
    categoryHealth,
    categoryEntertainment,
    categoryEducation,
    categoryOther,
  ];

  static const List<Color> walletPalette = [
    walletEmerald,
    categoryFood,
    categoryTransport,
    categoryShopping,
    categoryBills,
    categoryHealth,
    categoryEntertainment,
    categoryEducation,
    categoryOther,
  ];

  /// Category avatars show their colour at 16% behind the glyph.
  static const double categoryTintOpacity = 0.16;
}
