import 'package:flutter/material.dart';

/// Semantic colour tokens, 1:1 with the Figma "Color" collection
/// (Design_System.md → Colour Tokens). Widgets read colours only from here:
/// `MasroofyColors.of(context).surface`.
@immutable
class MasroofyColors extends ThemeExtension<MasroofyColors> {
  const MasroofyColors({
    required this.canvas,
    required this.surface,
    required this.surfaceVariant,
    required this.primary,
    required this.primarySubtle,
    required this.positive,
    required this.warning,
    required this.negative,
    required this.negativeSubtle,
    required this.track,
    required this.inverseSurface,
    required this.aura1,
    required this.aura2,
    required this.glassFill,
    required this.glassFillStrong,
    required this.glassStroke,
    required this.textPrimary,
    required this.textSecondary,
    required this.onPrimary,
    required this.textAccent,
    required this.textWarning,
    required this.textNegative,
    required this.onInverseSurface,
    required this.inverseAccent,
    required this.border,
    required this.borderFocus,
    required this.borderError,
  });

  MasroofyColors._fromList(List<Color> c)
    : this(
        canvas: c[0],
        surface: c[1],
        surfaceVariant: c[2],
        primary: c[3],
        primarySubtle: c[4],
        positive: c[5],
        warning: c[6],
        negative: c[7],
        negativeSubtle: c[8],
        track: c[9],
        inverseSurface: c[10],
        aura1: c[11],
        aura2: c[12],
        glassFill: c[13],
        glassFillStrong: c[14],
        glassStroke: c[15],
        textPrimary: c[16],
        textSecondary: c[17],
        onPrimary: c[18],
        textAccent: c[19],
        textWarning: c[20],
        textNegative: c[21],
        onInverseSurface: c[22],
        inverseAccent: c[23],
        border: c[24],
        borderFocus: c[25],
        borderError: c[26],
      );

  static MasroofyColors of(BuildContext context) => Theme.of(context).extension<MasroofyColors>()!;

  static const light = MasroofyColors(
    canvas: Color(0xFFF4F7F5),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFEAF0EC),
    primary: Color(0xFF047857),
    primarySubtle: Color(0xFFECFDF5),
    positive: Color(0xFF059669),
    warning: Color(0xFFF59E0B),
    negative: Color(0xFFDC2626),
    negativeSubtle: Color(0xFFFEF2F2),
    track: Color(0xFFDCE5E0),
    inverseSurface: Color(0xFF0B1A13),
    aura1: Color(0xFFA7F3D0),
    aura2: Color(0xFF99F6E4),
    glassFill: Color(0x99FFFFFF),
    glassFillStrong: Color(0xD1FFFFFF),
    glassStroke: Color(0xB3FFFFFF),
    textPrimary: Color(0xFF0B1A13),
    textSecondary: Color(0xFF5B6B63),
    onPrimary: Color(0xFFFFFFFF),
    textAccent: Color(0xFF047857),
    textWarning: Color(0xFF92400E),
    textNegative: Color(0xFFB91C1C),
    onInverseSurface: Color(0xFFFFFFFF),
    inverseAccent: Color(0xFF6EE7B7),
    border: Color(0xFFDCE5E0),
    borderFocus: Color(0xFF059669),
    borderError: Color(0xFFDC2626),
  );

  static const dark = MasroofyColors(
    canvas: Color(0xFF07110D),
    surface: Color(0xFF101C17),
    surfaceVariant: Color(0xFF17251F),
    primary: Color(0xFF34D399),
    primarySubtle: Color(0xFF022C22),
    positive: Color(0xFF34D399),
    warning: Color(0xFFFBBF24),
    negative: Color(0xFFF87171),
    negativeSubtle: Color(0xFF2A1414),
    track: Color(0xFF22332B),
    inverseSurface: Color(0xFFECF5F0),
    aura1: Color(0xFF064E3B),
    aura2: Color(0xFF134E4A),
    glassFill: Color(0x8C101C17),
    glassFillStrong: Color(0xB8101C17),
    glassStroke: Color(0x1FFFFFFF),
    textPrimary: Color(0xFFECF5F0),
    textSecondary: Color(0xFF93A69C),
    onPrimary: Color(0xFF07110D),
    textAccent: Color(0xFF6EE7B7),
    textWarning: Color(0xFFFBBF24),
    textNegative: Color(0xFFF87171),
    onInverseSurface: Color(0xFF0B1A13),
    inverseAccent: Color(0xFF047857),
    border: Color(0xFF22332B),
    borderFocus: Color(0xFF34D399),
    borderError: Color(0xFFF87171),
  );

  final Color canvas;
  final Color surface;
  final Color surfaceVariant;
  final Color primary;
  final Color primarySubtle;
  final Color positive;
  final Color warning;
  final Color negative;
  final Color negativeSubtle;
  final Color track;
  final Color inverseSurface;

  /// Blurred background glows behind content.
  final Color aura1;
  final Color aura2;

  /// Floating chrome only (tab bar, scrolled app bar, sheets, snackbar).
  final Color glassFill;
  final Color glassFillStrong;
  final Color glassStroke;

  final Color textPrimary;
  final Color textSecondary;
  final Color onPrimary;

  /// Also `text/positive`.
  final Color textAccent;
  final Color textWarning;
  final Color textNegative;
  final Color onInverseSurface;
  final Color inverseAccent;
  final Color border;
  final Color borderFocus;
  final Color borderError;

  Color get textPositive => textAccent;

  List<Color> get _all => [
    canvas, surface, surfaceVariant, primary, primarySubtle, positive, warning, negative, negativeSubtle, //
    track, inverseSurface, aura1, aura2, glassFill, glassFillStrong, glassStroke, textPrimary, textSecondary,
    onPrimary, textAccent, textWarning, textNegative, onInverseSurface, inverseAccent, border, borderFocus,
    borderError,
  ];

  /// Tokens are switched as a whole (light ↔ dark); per-token overrides are
  /// not supported, so this simply returns itself.
  @override
  MasroofyColors copyWith() => this;

  @override
  MasroofyColors lerp(MasroofyColors? other, double t) {
    if (other == null) return this;
    final a = _all;
    final b = other._all;
    return MasroofyColors._fromList([for (var i = 0; i < a.length; i++) Color.lerp(a[i], b[i], t)!]);
  }
}
