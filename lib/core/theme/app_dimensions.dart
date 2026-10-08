/// Spacing scale (Design_System.md → Shape, Spacing & Elevation).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Horizontal screen padding.
  static const double screen = lg;
}

abstract final class AppRadius {
  static const double input = 14;
  static const double card = 24;
  static const double sheet = 28;
  static const double full = 9999;
}

/// Glass chrome: `BackdropFilter` sigma for the Figma blur of 24.
abstract final class AppGlass {
  static const double blurSigma = 12;
}
