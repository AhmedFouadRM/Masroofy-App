import 'dart:async';

import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// The red button that must be held down to confirm (Settings PRD → Clear All
/// Data, step 2 without App Lock): a lighter overlay fills it over
/// [duration], and releasing early drains it again. A typed word would be
/// awkward on an Arabic keyboard, and a tap is too easy to do by accident.
class HoldToDeleteButton extends StatefulWidget {
  const HoldToDeleteButton({required this.onCompleted, this.duration = const Duration(seconds: 3), super.key});

  /// Called once, when the hold completes.
  final VoidCallback onCompleted;
  final Duration duration;

  @override
  State<HoldToDeleteButton> createState() => _HoldToDeleteButtonState();
}

class _HoldToDeleteButtonState extends State<HoldToDeleteButton> with SingleTickerProviderStateMixin {
  late final AnimationController _fill = AnimationController(vsync: this, duration: widget.duration)
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onCompleted();
    });

  @override
  void dispose() {
    _fill.dispose();
    super.dispose();
  }

  void _press() => unawaited(_fill.forward());

  /// Drains faster than it filled, so a slip is forgiven.
  void _release() {
    if (_fill.status != AnimationStatus.completed) unawaited(_fill.animateBack(0, duration: widget.duration ~/ 3));
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Semantics(
      button: true,
      label: StringManager.holdToDelete,
      // Holding is not possible with a screen reader, which long-presses instead.
      onLongPress: widget.onCompleted,
      excludeSemantics: true,
      child: Listener(
        onPointerDown: (_) => _press(),
        onPointerUp: (_) => _release(),
        onPointerCancel: (_) => _release(),
        child: Container(
          height: 52,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(shape: const StadiumBorder(), color: colors.negative),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _fill,
                  builder: (context, _) => Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FractionallySizedBox(
                      widthFactor: _fill.value,
                      heightFactor: 1,
                      child: ColoredBox(color: colors.onPrimary.withValues(alpha: 0.3)),
                    ),
                  ),
                ),
              ),
              Text(
                StringManager.holdToDelete,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: colors.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
