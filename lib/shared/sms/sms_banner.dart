import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

/// "From an SMS · CIB": the pill above the type control on an Add form that was
/// pre-filled from a bank message.
class SmsBanner extends StatelessWidget {
  const SmsBanner({required this.bank, super.key});

  /// The bank's display name.
  final String bank;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: StadiumBorder(side: BorderSide(color: colors.border)),
          color: colors.surfaceVariant,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.sms_rounded, size: 16, color: colors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  StringManager.smsFromBank(bank),
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(color: colors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
