import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// The small "Default" pill beside the default wallet's name.
class DefaultBadge extends StatelessWidget {
  const DefaultBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return DecoratedBox(
      decoration: ShapeDecoration(shape: const StadiumBorder(), color: colors.primarySubtle),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
        child: Text(
          StringManager.walletDefault,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(color: colors.textAccent),
        ),
      ),
    );
  }
}
