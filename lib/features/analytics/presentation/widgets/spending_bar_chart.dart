import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/analytics/domain/analytics_math.dart';
import 'package:masroofy/shared/formatting/display_format.dart';

/// Spending over time (Analytics PRD → Bar Chart): a pair of bars (income and
/// spending) per day, week or month, with a legend. The pair holding today is
/// lighter ("so far"). In RTL the time axis runs right to left and each pair
/// is mirrored, so income stays at the start side.
class SpendingBarChart extends StatelessWidget {
  const SpendingBarChart({
    required this.bars,
    required this.bucket,
    required this.range,
    required this.weekdayLabels,
    super.key,
  });

  /// Oldest first.
  final List<SpendingBar> bars;
  final DateRange range;
  final SpendingBucket bucket;

  /// Label day bars by weekday name (This Week) instead of date number.
  final bool weekdayLabels;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final today = LocalDate.today();
    final ordered = rtl ? bars.reversed.toList() : bars;
    final maxMinor = ordered.fold<int>(0, (max, bar) => math.max(max, math.max(bar.spent.minor, bar.income.minor)));
    final interval = AnalyticsMath.niceInterval(maxMinor.toDouble());
    final maxY = math.max(interval, (maxMinor / interval).ceil() * interval);
    // Thin out labels so they never collide.
    final labelEvery = (ordered.length / 8).ceil().clamp(1, 1 << 20);
    final axisStyle = text.labelSmall!.copyWith(color: colors.textSecondary);
    final locale = context.locale.languageCode;
    final incomeColor = colors.primary;
    final spentColor = colors.textSecondary;

    // The last bar starting on or before today holds it, if today is in range.
    final todayBar = range.contains(today) ? bars.lastIndexWhere((bar) => !bar.start.isAfter(today)) : -1;
    bool holdsToday(int i) => todayBar >= 0 && (rtl ? bars.length - 1 - i : i) == todayBar;

    String label(LocalDate start) => context.digits(switch (bucket) {
      SpendingBucket.day when weekdayLabels => DateFormat.E(locale).format(start.toDateTime()),
      SpendingBucket.day => '${start.day}',
      SpendingBucket.week => DateFormat.MMMd(locale).format(start.toDateTime()),
      SpendingBucket.month => DateFormat.MMM(locale).format(start.toDateTime()),
    });

    // fl_chart calls its builders outside `build`, where the formatting
    // extension may not read settings, so format everything up front.
    final labels = [for (final bar in ordered) label(bar.start)];
    final tooltips = [
      for (final bar in ordered) StringManager.incomeAndSpent(context.money(bar.income), context.money(bar.spent)),
    ];

    BarChartRodData rod(int minor, Color color, {required bool lighter}) => BarChartRodData(
      toY: minor.toDouble(),
      width: ordered.length > 20 ? 5 : 10,
      // A bucket with nothing draws nothing (not a rounded stub).
      color: minor == 0
          ? Colors.transparent
          : lighter
          ? color.withValues(alpha: 0.45)
          : color,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
    );

    List<BarChartRodData> pair(int i, SpendingBar bar) => [
      rod(bar.income.minor, incomeColor, lighter: holdsToday(i)),
      rod(bar.spent.minor, spentColor, lighter: holdsToday(i)),
    ];

    Widget legendItem(Color color, String name) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(name, style: axisStyle),
      ],
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            legendItem(incomeColor, StringManager.analyticsIncome),
            const SizedBox(width: AppSpacing.lg),
            legendItem(spentColor, StringManager.analyticsSpent),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: interval,
                getDrawingHorizontalLine: (_) => FlLine(color: colors.border, strokeWidth: 1, dashArray: [4, 4]),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      final fromStart = rtl ? ordered.length - 1 - i : i;
                      if (fromStart % labelEvery != 0) return const SizedBox.shrink();
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(labels[i], style: axisStyle),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => colors.inverseSurface,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipBorderRadius: BorderRadius.circular(8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
                    '${labels[group.x]}\n${tooltips[group.x]}',
                    text.labelMedium!.copyWith(color: colors.onInverseSurface),
                  ),
                ),
              ),
              barGroups: [
                for (final (i, bar) in ordered.indexed)
                  BarChartGroupData(
                    x: i,
                    barsSpace: 2,
                    // Income first; mirrored in RTL so it stays at the start.
                    barRods: rtl ? pair(i, bar).reversed.toList() : pair(i, bar),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
