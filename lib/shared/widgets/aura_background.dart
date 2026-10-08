import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// The canvas with the soft emerald glows behind the top of a screen.
class AuraBackground extends StatelessWidget {
  const AuraBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(color: colors.canvas),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: AlignmentDirectional.topStart.resolve(Directionality.of(context)),
                  radius: 1.1,
                  colors: [colors.aura1.withValues(alpha: 0.7), colors.aura1.withValues(alpha: 0)],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: AlignmentDirectional.topEnd.resolve(Directionality.of(context)),
                  radius: 0.9,
                  colors: [colors.aura2.withValues(alpha: 0.6), colors.aura2.withValues(alpha: 0)],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
