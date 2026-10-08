import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// Figma "App Bar": clear at rest; once content scrolls under it, a
/// progressive blur frosts that content (iOS 26 scroll-edge effect).
///
/// Use with `Scaffold(extendBodyBehindAppBar: true)` and pad scroll views by
/// `MediaQuery.paddingOf(context).top` so content starts below the bar.
class GlassAppBar extends StatefulWidget implements PreferredSizeWidget {
  const GlassAppBar({required this.title, this.leading, this.actions, super.key});

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<GlassAppBar> createState() => _GlassAppBarState();
}

class _GlassAppBarState extends State<GlassAppBar> {
  ScrollNotificationObserverState? _observer;
  bool _scrolled = false;

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
    final scrolled = notification.metrics.extentBefore > 0;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return AppBar(
      leading: widget.leading,
      title: widget.title,
      actions: widget.actions,
      flexibleSpace: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _scrolled ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Strongest at the top, easing to sharp at the bar's lower
              // edge, so there is no hard line where the frost ends.
              const ProgressiveBlur(maxSigma: 16, falloff: 0.8),
              // Canvas tint keeps the title readable over dark content.
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
    );
  }
}
