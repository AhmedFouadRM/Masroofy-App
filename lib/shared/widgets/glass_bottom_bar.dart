import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// The bottom twin of [GlassAppBar]: a pinned action (Save, Continue) over
/// the page. While content runs on below it, a progressive blur frosts that
/// content, strongest at the bottom edge, so the button floats on glass
/// instead of a hard cut.
///
/// Use as `Scaffold.bottomNavigationBar` with `extendBody: true`, and pad
/// scroll views by `MediaQuery.paddingOf(context).bottom` so their end clears
/// the bar.
class GlassBottomBar extends StatefulWidget {
  const GlassBottomBar({required this.child, super.key});

  /// Usually one full-width `FilledButton`.
  final Widget child;

  @override
  State<GlassBottomBar> createState() => _GlassBottomBarState();
}

class _GlassBottomBarState extends State<GlassBottomBar> {
  ScrollNotificationObserverState? _observer;
  bool _contentBelow = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observer?.removeListener(_onScroll);
    _observer = ScrollNotificationObserver.maybeOf(context)?..addListener(_onScroll);
  }

  @override
  void dispose() {
    _observer?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll(ScrollNotification notification) {
    // Only the page's own vertical scroll (not nested chip rows).
    if (notification.depth != 0 || notification.metrics.axis != Axis.vertical) return;
    final below = notification.metrics.extentAfter > 0;
    if (below != _contentBelow) setState(() => _contentBelow = below);
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _contentBelow ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Strongest at the bottom, easing to sharp at the bar's
                  // top edge, so there is no hard line where the frost ends.
                  const ProgressiveBlur(
                    maxSigma: 16,
                    falloff: 0.8,
                    direction: ProgressiveBlurDirection.bottomToTop,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0, 0.6, 1],
                        colors: [
                          colors.canvas.withValues(alpha: 0.9),
                          colors.canvas.withValues(alpha: 0.65),
                          colors.canvas.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.lg),
          child: widget.child,
        ),
      ],
    );
  }
}
