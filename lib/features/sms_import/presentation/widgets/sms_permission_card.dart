import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Figma "permission warning": a surface card with a warning border, the
/// [message] and an **Open settings** button.
class SmsPermissionCard extends StatelessWidget {
  const SmsPermissionCard({required this.message, required this.onOpenSettings, super.key});

  final String message;
  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: colors.textWarning),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Symbols.warning_rounded, color: colors.textWarning),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(message, style: Theme.of(context).textTheme.bodyMedium)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(onPressed: onOpenSettings, child: Text(StringManager.smsOpenSettings)),
            ],
          ),
        ),
      ),
    );
  }
}
