import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The emerald add button with its soft glow, for full-screen lists.
class GlowingFab extends StatelessWidget {
  const GlowingFab({required this.tooltip, required this.onPressed, super.key});

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: colors.primary.withValues(alpha: 0.32), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: FloatingActionButton(tooltip: tooltip, onPressed: onPressed, child: const Icon(Symbols.add_rounded)),
    );
  }
}
