import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/analytics/domain/analytics_math.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';

/// Category breakdown as a donut (Analytics PRD → Pie Chart). The centre
/// shows the period total, or the tapped slice's name, amount and share.
class SpendingPieChart extends StatefulWidget {
  const SpendingPieChart({required this.slices, required this.categories, required this.total, super.key});

  final List<SpendingSlice> slices;
  final Map<int, Category> categories;
  final Money total;

  @override
  State<SpendingPieChart> createState() => _SpendingPieChartState();
}

class _SpendingPieChartState extends State<SpendingPieChart> {
  int? _touched;

  @override
  void didUpdateWidget(SpendingPieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_touched != null && _touched! >= widget.slices.length) _touched = null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final touched = _touched == null ? null : widget.slices[_touched!];

    Color colorOf(SpendingSlice slice) => switch (slice.categoryId) {
      final id? => Color(widget.categories[id]?.color ?? colors.textSecondary.toARGB32()),
      null => colors.textSecondary.withValues(alpha: 0.5),
    };

    String nameOf(SpendingSlice slice) => switch (slice.categoryId) {
      final id? => widget.categories[id]?.displayName ?? '',
      null => StringManager.smallerCategories,
    };

    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: 72,
              sectionsSpace: 2,
              startDegreeOffset: -90,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions) return;
                  final index = response?.touchedSection?.touchedSectionIndex;
                  if (event is FlTapUpEvent) {
                    setState(() => _touched = index == null || index < 0 || index == _touched ? null : index);
                  }
                },
              ),
              sections: [
                for (final (i, slice) in widget.slices.indexed)
                  PieChartSectionData(
                    value: slice.total.minor.toDouble(),
                    color: colorOf(slice),
                    radius: i == _touched ? 36 : 28,
                    showTitle: false,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120 - 72 + AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  touched == null ? StringManager.total : nameOf(touched),
                  style: text.labelMedium!.copyWith(color: colors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(context.money(touched?.total ?? widget.total), style: text.titleLarge),
                ),
                if (touched != null)
                  Text(
                    StringManager.percentOfTotal(context.count(_percent(touched.total))),
                    style: text.labelMedium!.copyWith(color: colors.textSecondary),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _percent(Money amount) => widget.total.minor == 0 ? 0 : (amount.minor * 100 / widget.total.minor).round();
}
