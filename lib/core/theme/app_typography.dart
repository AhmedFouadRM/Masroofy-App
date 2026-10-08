import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/thmanyah_font_loader.dart';

/// Type scale (Design_System.md → Typography): Sora for English, Thmanyah
/// Sans for Arabic, each falling back to the other per glyph. Arabic gets
/// taller lines and its own weights (Thmanyah has Medium and Bold, no SemiBold).
///
/// Material slot mapping: displayMedium = Display/Balance, displaySmall =
/// Amount/Large, headlineSmall, titleLarge, titleMedium, body*, label*.
abstract final class AppTypography {
  static const sora = 'Sora';

  static TextTheme textTheme({required bool arabic, required Color color}) {
    final family = arabic ? ThmanyahFontLoader.family : sora;
    final fallback = [if (arabic) sora else ThmanyahFontLoader.family];
    const semiBold = FontWeight.w600;
    final strong = arabic ? FontWeight.w700 : semiBold;
    final medium = arabic ? FontWeight.w500 : semiBold;

    TextStyle style(double size, double lineEn, double lineAr, FontWeight weight, {bool tabular = false}) => TextStyle(
      fontFamily: family,
      fontFamilyFallback: fallback,
      fontSize: size,
      height: (arabic ? lineAr : lineEn) / size,
      fontWeight: weight,
      color: color,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
      leadingDistribution: TextLeadingDistribution.even,
    );

    return TextTheme(
      displayMedium: style(44, 52, 60, strong, tabular: true),
      displaySmall: style(34, 42, 50, strong, tabular: true),
      headlineSmall: style(24, 32, 40, medium),
      titleLarge: style(22, 28, 36, FontWeight.w400),
      titleMedium: style(16, 24, 28, medium),
      bodyLarge: style(16, 24, 28, FontWeight.w400),
      bodyMedium: style(14, 20, 24, FontWeight.w400),
      bodySmall: style(12, 16, 20, FontWeight.w400),
      labelLarge: style(14, 20, 24, medium),
      labelMedium: style(12, 16, 20, medium),
      labelSmall: style(11, 16, 18, medium),
    );
  }
}
