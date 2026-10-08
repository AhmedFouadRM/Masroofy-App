import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// Liquid glass for floating chrome only (Design_System.md → Glass rules):
/// a shader lens that blurs and bends the content behind it, with specular
/// highlights on the rim (liquid_glass_widgets). Falls back to a solid
/// surface when the platform asks for high contrast.
class GlassSurface extends StatelessWidget {
  const GlassSurface({required this.child, required this.radius, this.strong = false, super.key});

  final Widget child;

  /// Uniform corner radius of the squircle.
  final double radius;

  /// A denser tint when the glass holds text over busy content.
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    if (MediaQuery.highContrastOf(context)) {
      return DecoratedBox(
        decoration: ShapeDecoration(
          color: colors.surface,
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(radius),
            side: BorderSide(color: colors.border),
          ),
        ),
        child: child,
      );
    }
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GlassContainer(
      useOwnLayer: true,
      shape: LiquidRoundedSuperellipse(borderRadius: radius),
      settings: LiquidGlassSettings(
        // A light tint keeps the text readable while the content behind
        // still shows through, bent at the rim.
        glassColor: (dark ? colors.surface : Colors.white).withValues(alpha: strong ? 0.55 : 0.35),
        thickness: 24,
        blur: strong ? 10 : 6,
        refractiveIndex: 1.25,
        lightIntensity: dark ? 0.35 : 0.6,
        saturation: 1.4,
      ),
      child: child,
    );
  }
}
