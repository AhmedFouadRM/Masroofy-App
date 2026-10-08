import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/app_typography.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// Material 3 themes built from the Masroofy tokens. Rebuilt when the
/// language changes because Arabic uses its own font, weights and line heights.
abstract final class AppTheme {
  static ThemeData light({required bool arabic}) => _build(MasroofyColors.light, Brightness.light, arabic: arabic);

  static ThemeData dark({required bool arabic}) => _build(MasroofyColors.dark, Brightness.dark, arabic: arabic);

  static ThemeData _build(MasroofyColors c, Brightness brightness, {required bool arabic}) {
    final textTheme = AppTypography.textTheme(arabic: arabic, color: c.textPrimary);
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.onPrimary,
      primaryContainer: c.primarySubtle,
      onPrimaryContainer: c.textAccent,
      secondary: c.primary,
      onSecondary: c.onPrimary,
      error: c.negative,
      onError: c.onPrimary,
      errorContainer: c.negativeSubtle,
      onErrorContainer: c.textNegative,
      surface: c.surface,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerLowest: c.surface,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surfaceVariant,
      surfaceContainerHigh: c.surfaceVariant,
      surfaceContainerHighest: c.surfaceVariant,
      outline: c.border,
      outlineVariant: c.border,
      inverseSurface: c.inverseSurface,
      onInverseSurface: c.onInverseSurface,
      inversePrimary: c.inverseAccent,
    );
    const pill = StadiumBorder();
    OutlineInputBorder inputBorder(Color color, [double width = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      borderSide: BorderSide(color: color, width: width),
    );
    final buttonText = textTheme.labelLarge;
    const buttonSize = Size(64, 52);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      extensions: [c],
      textTheme: textTheme,
      fontFamily: textTheme.bodyMedium!.fontFamily,
      fontFamilyFallback: textTheme.bodyMedium!.fontFamilyFallback,
      scaffoldBackgroundColor: c.canvas,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: c.textPrimary,
        titleTextStyle: textTheme.headlineSmall,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        border: inputBorder(c.border),
        enabledBorder: inputBorder(c.border),
        focusedBorder: inputBorder(c.borderFocus, 2),
        errorBorder: inputBorder(c.borderError),
        focusedErrorBorder: inputBorder(c.borderError, 2),
        labelStyle: textTheme.bodyLarge!.copyWith(color: c.textSecondary),
        floatingLabelStyle: textTheme.labelMedium!.copyWith(color: c.textAccent),
        helperStyle: textTheme.bodySmall!.copyWith(color: c.textSecondary),
        errorStyle: textTheme.bodySmall!.copyWith(color: c.textNegative),
        hintStyle: textTheme.bodyLarge!.copyWith(color: c.textSecondary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: pill,
          minimumSize: buttonSize,
          textStyle: buttonText,
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: pill,
          minimumSize: buttonSize,
          textStyle: buttonText,
          foregroundColor: c.textAccent,
          side: BorderSide(color: c.border),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: pill, textStyle: buttonText, foregroundColor: c.textAccent),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.primary,
        foregroundColor: c.onPrimary,
        shape: const CircleBorder(),
        elevation: 0,
        highlightElevation: 0,
      ),
      chipTheme: ChipThemeData(
        shape: pill,
        backgroundColor: c.surface,
        selectedColor: c.primarySubtle,
        side: BorderSide(color: c.border),
        labelStyle: textTheme.labelLarge,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        barrierColor: c.inverseSurface.withValues(alpha: 0.32),
        shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(AppRadius.sheet)),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium!.copyWith(color: c.textSecondary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        // Solid by default; glass sheets use `showGlassSheet`.
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: c.inverseSurface.withValues(alpha: 0.32),
        showDragHandle: true,
        dragHandleColor: c.border,
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: c.inverseSurface,
        contentTextStyle: textTheme.bodyMedium!.copyWith(color: c.onInverseSurface),
        actionTextColor: c.inverseAccent,
        shape: const StadiumBorder(),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.onPrimary : c.surface),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.primary : c.track),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        iconColor: c.textSecondary,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall!.copyWith(color: c.textSecondary),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        minVerticalPadding: AppSpacing.md,
      ),
    );
  }
}
