import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// Figma "Dialog": a tinted icon, a title, a message, and a Cancel button
/// beside [confirm]. [destructive] tints the icon red.
class IconDialog extends StatelessWidget {
  const IconDialog({
    required this.icon,
    required this.title,
    required this.message,
    required this.confirm,
    this.cancelLabel,
    this.destructive = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  /// The primary action; it pops the dialog itself.
  final Widget confirm;

  /// Defaults to "Cancel".
  final String? cancelLabel;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: destructive ? colors.negativeSubtle : colors.primarySubtle,
              ),
              child: Icon(icon, color: destructive ? colors.negative : colors.primary, size: 24),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: text.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: text.bodyMedium!.copyWith(color: colors.textSecondary)),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(cancelLabel ?? StringManager.cancel),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: confirm),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows an [IconDialog] with a filled confirm button; resolves to whether it
/// was confirmed (false when cancelled or dismissed).
Future<bool> showIconConfirmDialog(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colors = MasroofyColors.of(context);
      return IconDialog(
        icon: icon,
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        destructive: destructive,
        confirm: FilledButton(
          style: destructive
              ? FilledButton.styleFrom(backgroundColor: colors.negative, foregroundColor: colors.onPrimary)
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      );
    },
  );
  return confirmed ?? false;
}
