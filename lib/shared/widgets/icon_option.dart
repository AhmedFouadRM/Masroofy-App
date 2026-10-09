import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// A selectable icon tile (Figma local component "Icon Option"): the glyph in
/// [accent] when selected, with an emerald ring.
class IconOption extends StatelessWidget {
  const IconOption({required this.icon, required this.selected, required this.accent, required this.onTap, super.key});

  final IconData icon;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final shape = RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
      side: selected ? BorderSide(color: colors.primary, width: 2) : BorderSide.none,
    );
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? colors.primarySubtle : colors.surfaceVariant,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Icon(icon, color: selected ? accent : colors.textPrimary),
        ),
      ),
    );
  }
}
