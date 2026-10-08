import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// Figma "Segmented Control": equal pills on a track; the selected one is a
/// raised surface.
class SegmentedPills extends StatelessWidget {
  const SegmentedPills({required this.labels, required this.selected, required this.onSelected, super.key});

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: ShapeDecoration(shape: const StadiumBorder(), color: colors.surfaceVariant),
      child: Row(
        children: [
          for (final (i, label) in labels.indexed)
            Expanded(
              child: Semantics(
                selected: i == selected,
                button: true,
                child: Material(
                  color: i == selected ? colors.surface : Colors.transparent,
                  shape: const StadiumBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => onSelected(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.labelLarge!.copyWith(
                          color: i == selected ? colors.textPrimary : colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
