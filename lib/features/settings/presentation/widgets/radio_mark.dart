import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// The radio circle of a choice row: a ring, with a dot when [selected].
/// Purely visual; the row around it handles taps and semantics.
class RadioMark extends StatelessWidget {
  const RadioMark({required this.selected, super.key});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? colors.primary : colors.border, width: 2),
      ),
      child: selected
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(shape: BoxShape.circle, color: colors.primary),
            )
          : null,
    );
  }
}
