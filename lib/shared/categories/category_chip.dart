import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// Figma "Category Chip": a pill with a coloured glyph and a label; selected
/// chips get the emerald tint and outline.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? colors.primarySubtle : colors.surface,
        shape: StadiumBorder(
          side: BorderSide(color: selected ? colors.primary : colors.border, width: selected ? 1.5 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md + 2, vertical: AppSpacing.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: selected ? colors.textAccent : colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
