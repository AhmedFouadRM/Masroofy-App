import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A row of a Settings card (Figma "Settings Row"): a tinted icon, a title
/// with an optional subtitle, and at the end either a [value] with a chevron,
/// or a custom [trailing] such as a switch. [destructive] paints it red.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.destructive = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// The current choice, shown before the chevron.
  final String? value;

  /// Replaces the value and chevron.
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final tint = destructive ? colors.negative : colors.textSecondary;
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: destructive ? colors.negativeSubtle : colors.surfaceVariant,
        ),
        child: Icon(icon, color: destructive ? colors.negative : colors.textPrimary, size: 22),
      ),
      title: Text(title, style: text.bodyLarge!.copyWith(color: destructive ? colors.textNegative : null)),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing:
          trailing ??
          (onTap == null
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (value != null) Text(value!, style: text.bodyMedium!.copyWith(color: colors.textSecondary)),
                    Icon(Symbols.chevron_forward_rounded, color: tint),
                  ],
                )),
      onTap: onTap,
    );
  }
}
