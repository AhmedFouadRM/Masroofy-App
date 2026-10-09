import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The small "SMS" mark under the amount of a transaction that was added from
/// a bank message (Figma "Transactions — SMS badge").
class SmsBadge extends StatelessWidget {
  const SmsBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Semantics(
      label: StringManager.smsBadgeSemantics,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.sms_rounded, size: 14, color: colors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            StringManager.smsBadge,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
