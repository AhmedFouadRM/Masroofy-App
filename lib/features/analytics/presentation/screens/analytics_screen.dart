import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_cubit.dart';
import 'package:masroofy/features/analytics/presentation/widgets/spending_bar_chart.dart';
import 'package:masroofy/features/analytics/presentation/widgets/spending_pie_chart.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/shared/categories/category_avatar.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/widgets/app_shell.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/empty_state_widget.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/grouped_list.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
import 'package:masroofy/shared/widgets/summary_card.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The Analytics tab. Expects an [AnalyticsCubit] above it.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: GlassAppBar(title: Text(StringManager.analyticsTitle)),
        body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
          builder: (context, state) => ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              MediaQuery.paddingOf(context).top + AppSpacing.sm,
              AppSpacing.screen,
              AppShell.bottomInset,
            ),
            children: [
              _Summary(state: state),
              const SizedBox(height: AppSpacing.lg),
              _PeriodPills(state: state),
              ...switch (state.status) {
                AnalyticsStatus.loading => [
                  const Padding(
                    padding: EdgeInsets.all(AppSpacing.xxxl),
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  ),
                ],
                AnalyticsStatus.failure => [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Text(StringManager.failure(state.failure!), textAlign: TextAlign.center),
                  ),
                ],
                AnalyticsStatus.loaded when state.isEmpty => [
                  EmptyStateWidget(
                    icon: Symbols.bar_chart_rounded,
                    title: StringManager.noAnalyticsData,
                    message: StringManager.noAnalyticsDataHint,
                  ),
                ],
                AnalyticsStatus.loaded => [
                  SectionHeader(title: StringManager.byCategory),
                  _CategoryBreakdown(state: state),
                  SectionHeader(title: StringManager.spendingOverTime),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.xl, AppSpacing.md, AppSpacing.md),
                      child: SpendingBarChart(
                        bars: state.bars,
                        bucket: state.bucket,
                        range: state.range,
                        weekdayLabels: state.period == AnalyticsPeriod.week,
                      ),
                    ),
                  ),
                ],
              },
            ],
          ),
        ),
      ),
    );
  }
}

String _rangeLabel(BuildContext context, DateRange range) =>
    '${context.shortDate(range.start)} – ${context.shortDate(range.end)}';

class _Summary extends StatelessWidget {
  const _Summary({required this.state});

  final AnalyticsState state;

  @override
  Widget build(BuildContext context) {
    final (label, comparison) = switch (state.period) {
      AnalyticsPeriod.week => (StringManager.spentThisWeek, StringManager.vsLastWeek),
      AnalyticsPeriod.month => (StringManager.spentThisMonth, StringManager.vsLastMonth),
      AnalyticsPeriod.lastMonth => (StringManager.spentLastMonth, StringManager.vsMonthBefore),
      AnalyticsPeriod.custom => (
        StringManager.spentInRange(_rangeLabel(context, state.range)),
        StringManager.vsPreviousPeriod,
      ),
    };
    return SummaryCard(
      label: label,
      total: state.total,
      previousTotal: state.previousTotal,
      comparisonLabel: comparison,
    );
  }
}

class _PeriodPills extends StatelessWidget {
  const _PeriodPills({required this.state});

  final AnalyticsState state;

  Future<void> _pickRange(BuildContext context) async {
    final cubit = context.read<AnalyticsCubit>();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: LocalDate.today().toDateTime(),
      initialDateRange: DateTimeRange(start: state.range.start.toDateTime(), end: state.range.end.toDateTime()),
    );
    if (picked == null) return;
    cubit.selectCustomRange(DateRange(LocalDate.fromDateTime(picked.start), LocalDate.fromDateTime(picked.end)));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnalyticsCubit>();
    return SegmentedPills(
      labels: [
        StringManager.thisWeek,
        StringManager.thisMonth,
        StringManager.lastMonth,
        if (state.period == AnalyticsPeriod.custom) _rangeLabel(context, state.range) else StringManager.customRange,
      ],
      selected: state.period.index,
      onSelected: (i) => switch (AnalyticsPeriod.values[i]) {
        AnalyticsPeriod.custom => _pickRange(context),
        final period => cubit.selectPeriod(period),
      },
    );
  }
}

/// The donut, then every category with its share, largest first.
class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.state});

  final AnalyticsState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: SpendingPieChart(slices: state.slices, categories: state.categories, total: state.total),
          ),
          for (final (category, amount) in state.legend) ...[
            const Divider(indent: 72),
            _LegendRow(category: category, amount: amount, total: state.total),
          ],
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.category, required this.amount, required this.total});

  final Category category;
  final Money amount;
  final Money total;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final share = amount.minor / total.minor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          CategoryAvatar(icon: category.icon, color: category.color),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.displayName,
                        style: text.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(context.money(amount), style: text.titleMedium),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: LinearProgressIndicator(
                          value: share,
                          minHeight: 6,
                          color: Color(category.color),
                          backgroundColor: colors.track,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${context.count((share * 100).round())}%',
                        textAlign: TextAlign.end,
                        style: text.labelMedium!.copyWith(color: colors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
