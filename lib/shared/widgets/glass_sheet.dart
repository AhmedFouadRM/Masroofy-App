import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Figma "Bottom Sheet": a glass sheet on the bottom edge (Glass/Chrome blur,
/// glass/fill-strong, glass/stroke, `radius/sheet` top corners) with a
/// handle, the [title] and a close button above the content (the slot).
/// The scrim comes from the theme (bg/inverse at 32%).
Future<T?> showGlassSheet<T>(
  BuildContext context, {
  required String title,
  required WidgetBuilder builder,
}) => showModalBottomSheet<T>(
  context: context,
  // Above the tab bar, so it is dimmed and blocked like the rest of the page.
  useRootNavigator: true,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  elevation: 0,
  showDragHandle: false,
  builder: (context) => _GlassSheet(title: title, child: builder(context)),
);

class _GlassSheet extends StatelessWidget {
  const _GlassSheet({required this.title, required this.child});

  final String title;
  final Widget child;

  static const _shape = BorderRadius.vertical(top: Radius.circular(AppRadius.sheet));

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final highContrast = MediaQuery.highContrastOf(context);
    // 32 below the content, or clear of the system navigation if that's taller.
    final bottom = math.max(AppSpacing.xxl, MediaQuery.viewPaddingOf(context).bottom + AppSpacing.lg);

    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: highContrast ? colors.surface : colors.glassFillStrong,
        borderRadius: _shape,
        border: Border(
          top: BorderSide(color: highContrast ? colors.border : colors.glassStroke),
        ),
      ),
      // Rows (ListTile, InkWell) paint their ink here, above the tint.
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: ShapeDecoration(shape: const StadiumBorder(), color: colors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Symbols.close_rounded),
                    tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                    style: IconButton.styleFrom(
                      backgroundColor: colors.surfaceVariant,
                      foregroundColor: colors.textPrimary,
                      fixedSize: const Size.square(40),
                      minimumSize: const Size.square(40),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Flexible(child: child),
            ],
          ),
        ),
      ),
    );

    return ClipRRect(
      borderRadius: _shape,
      child: highContrast
          ? content
          : BackdropFilter(
              filter: ImageFilter.blur(sigmaX: AppGlass.blurSigma, sigmaY: AppGlass.blurSigma),
              child: content,
            ),
    );
  }
}
