import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The shared body of the PIN screens (Figma "Auth"): a tinted icon, a title,
/// one line of message, the dots, an optional note, and the keypad at the bottom.
class PinScreenLayout extends StatelessWidget {
  const PinScreenLayout({
    required this.icon,
    required this.title,
    required this.message,
    required this.dots,
    required this.keypad,
    this.messageColor,
    this.note,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  /// Defaults to the secondary text colour; errors pass a stronger one.
  final Color? messageColor;
  final Widget dots;
  final Widget keypad;

  /// An info box under the dots (the forgotten-PIN note).
  final Widget? note;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.lg),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: colors.primarySubtle),
                  child: Icon(icon, color: colors.primary, size: 32),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(title, style: text.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                // Live region: a wrong PIN or a countdown is announced.
                Semantics(
                  liveRegion: true,
                  child: Text(
                    message,
                    style: text.bodyMedium!.copyWith(color: messageColor ?? colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                dots,
                if (note != null) ...[const SizedBox(height: AppSpacing.lg), note!],
                const Spacer(),
                keypad,
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The forgotten-PIN note on the Set PIN screen.
class PinNote extends StatelessWidget {
  const PinNote({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.surfaceVariant, borderRadius: BorderRadius.circular(AppRadius.input)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Symbols.info_rounded, size: 18, color: colors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: colors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
