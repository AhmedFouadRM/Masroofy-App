import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// Frosted glass for floating chrome only (Design_System.md → Glass rules):
/// background blur + translucent fill + 1px highlight stroke. Falls back to
/// a solid surface when the platform asks for high contrast.
class GlassSurface extends StatelessWidget {
  const GlassSurface({required this.child, required this.borderRadius, this.strong = false, super.key});

  final Widget child;
  final BorderRadius borderRadius;

  /// Use the stronger fill when the glass holds text.
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final solid = MediaQuery.highContrastOf(context);
    final shape = RoundedSuperellipseBorder(
      borderRadius: borderRadius,
      side: BorderSide(color: solid ? colors.border : colors.glassStroke),
    );
    final surface = DecoratedBox(
      decoration: ShapeDecoration(
        shape: shape,
        color: solid ? colors.surface : (strong ? colors.glassFillStrong : colors.glassFill),
        shadows: [
          BoxShadow(color: colors.inverseSurface.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: child,
    );
    if (solid) return surface;
    return ClipRSuperellipse(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppGlass.blurSigma, sigmaY: AppGlass.blurSigma),
        child: surface,
      ),
    );
  }
}
