import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_colors.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_cubit.dart';
import 'package:masroofy/features/analytics/presentation/widgets/spending_bar_chart.dart';
import 'package:masroofy/features/analytics/presentation/widgets/spending_pie_chart.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/shared/budgets/budget_progress_row.dart';
import 'package:masroofy/shared/categories/category_avatar.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/wallets/wallet_avatar.dart';
import 'package:masroofy/shared/wallets/wallet_display.dart';
import 'package:masroofy/shared/wallets/wallet_switcher.dart';
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
    // The wallet switcher (here or on another tab) stores the choice.
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) => previous.viewedWalletId != current.viewedWalletId,
      listener: (context, settings) => context.read<AnalyticsCubit>().selectWallet(settings.viewedWalletId),
      child: AuraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(
            title: BlocBuilder<AnalyticsCubit, AnalyticsState>(
              buildWhen: (previous, current) => previous.walletSummaries != current.walletSummaries,
              builder: (context, state) =>
                  WalletSwitcher(wallets: state.walletSummaries, fallbackTitle: StringManager.analyticsTitle),
            ),
          ),
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
                const SizedBox(height: AppSpacing.sm),
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
                    ..._budgetSection(state),
                  ],
                  AnalyticsStatus.loaded => [
                    ..._titled(StringManager.incomeVsSpending, [
                      _IncomeVsSpending(totals: state.totals, showsTransfers: !state.showsByWallet),
                    ]),
                    if (state.showsByWallet && state.wallets.length > 1)
                      ..._titled(StringManager.byWallet, [_WalletBreakdown(state: state)]),
                    ..._titled(StringManager.byCategory, [_CategoryBreakdown(state: state)]),
                    ..._titled(StringManager.spendingOverTime, [
                      // Income and transfers never show up as spending bars.
                      if (state.total.isPositive)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.md,
                              AppSpacing.xl,
                              AppSpacing.md,
                              AppSpacing.md,
                            ),
                            child: SpendingBarChart(
                              bars: state.bars,
                              bucket: state.bucket,
                              range: state.range,
                              weekdayLabels: state.period == AnalyticsPeriod.week,
                            ),
                          ),
                        )
                      else
                        _InlineEmptyCard(message: StringManager.noSpendingInPeriod),
                    ]),
                    ..._budgetSection(state),
                  ],
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A section: its header, the 8 gap the Figma column puts between a header and
/// what it titles, then [children].
List<Widget> _titled(String title, List<Widget> children) => [
  SectionHeader(title: title),
  const SizedBox(height: AppSpacing.sm),
  ...children,
];

/// Budget progress (Analytics PRD → flow step 2d): each budget in its own
/// current week or month, whatever range is selected. Hidden when there are
/// no budgets.
List<Widget> _budgetSection(AnalyticsState state) => [
  if (state.budgets.isNotEmpty)
    ..._titled(StringManager.budgetsTitle, [
      GroupedCard(
        children: [
          for (final progress in state.budgets)
            BudgetProgressRow(
              progress: progress,
              category: state.categories[progress.budget.categoryId],
              periodLabel: switch (progress.budget.period) {
                BudgetPeriod.weekly => StringManager.thisWeek,
                BudgetPeriod.monthly => StringManager.thisMonth,
              },
            ),
        ],
      ),
    ]),
];

String _rangeLabel(BuildContext context, DateRange range) =>
    '${context.shortDate(range.start)} – ${context.shortDate(range.end)}';

class _Summary extends StatelessWidget {
  const _Summary({required this.state});

  final AnalyticsState state;

  @override
  Widget build(BuildContext context) {
    final (label, comparison, noChange) = switch (state.period) {
      AnalyticsPeriod.week => (
        StringManager.spentThisWeek,
        StringManager.vsLastWeek,
        StringManager.noChangeVsLastWeek,
      ),
      AnalyticsPeriod.month => (
        StringManager.spentThisMonth,
        StringManager.vsLastMonth,
        StringManager.noChangeVsLastMonth,
      ),
      AnalyticsPeriod.lastMonth => (
        StringManager.spentLastMonth,
        StringManager.vsMonthBefore,
        StringManager.noChangeVsMonthBefore,
      ),
      AnalyticsPeriod.custom => (
        StringManager.spentInRange(_rangeLabel(context, state.range)),
        StringManager.vsPreviousPeriod,
        StringManager.noChangeVsPreviousPeriod,
      ),
    };
    return SummaryCard(
      label: label,
      total: state.total,
      previousTotal: state.previousTotal,
      comparisonLabel: comparison,
      // A period with activity but unchanged spending reads "No change"
      // (Figma); a wholly empty one shows no comparison (Analytics PRD).
      noChangeLabel: state.isEmpty ? null : noChange,
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

/// Income, spending, (in one wallet) transfers, the balance and the savings
/// rate for the selected period: one row each on a grouped card, split by
/// 1 px dividers (Figma "Income vs spending card").
class _IncomeVsSpending extends StatelessWidget {
  const _IncomeVsSpending({required this.totals, required this.showsTransfers});

  final PeriodTotals totals;

  /// One wallet: its transfers in and out get a row. Over all wallets they
  /// cancel out, so there is nothing to show.
  final bool showsTransfers;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final balance = totals.balance;
    final rate = totals.savingsRate;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _StatRow(
            icon: Symbols.south_west_rounded,
            color: AppColors.walletEmerald,
            label: StringManager.analyticsIncome,
            value: Text(context.money(totals.income), style: text.titleMedium!.copyWith(color: colors.textPositive)),
          ),
          const Divider(),
          _StatRow(
            icon: Symbols.north_east_rounded,
            color: AppColors.categoryHealth,
            label: StringManager.analyticsSpent,
            value: Text(context.money(totals.spent), style: text.titleMedium),
          ),
          if (showsTransfers && totals.hasTransfers) ...[
            const Divider(),
            _StatRow(
              icon: Symbols.sync_alt_rounded,
              color: AppColors.categoryEducation,
              label: StringManager.analyticsTransfers,
              value: Text(
                StringManager.transfersInOut(
                  context.signedMoney(totals.transfersIn),
                  context.money(totals.transfersOut),
                ),
                style: text.labelMedium!.copyWith(color: colors.textSecondary),
              ),
            ),
          ],
          const Divider(),
          _StatRow(
            icon: Symbols.account_balance_wallet_rounded,
            color: AppColors.categoryTransport,
            label: StringManager.analyticsBalance,
            value: Text(
              context.signedMoney(balance, plus: false),
              style: text.titleMedium!.copyWith(color: balance.isNegative ? colors.textNegative : null),
            ),
          ),
          // Hidden when nothing came in: there is nothing to save from.
          if (rate != null) ...[
            const Divider(),
            _StatRow(
              icon: Symbols.savings_rounded,
              color: AppColors.categoryEducation,
              label: StringManager.savingsRate,
              value: Text(
                '${rate < 0 ? '−' : ''}${context.count((rate.abs() * 100).round())}%',
                textDirection: TextDirection.ltr,
                style: text.titleMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A row of the Income vs spending card: a 32 avatar with an 18 glyph, the
/// label, and the amount at the end. 12 / 16 padding and 12 between the parts
/// make it 56 high.
class _StatRow extends StatelessWidget {
  const _StatRow({required this.icon, required this.color, required this.label, required this.value});

  final IconData icon;
  final Color color;
  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: AppColors.categoryTintOpacity),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // A long amount scales down rather than crowding the label out.
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.6),
              child: FittedBox(fit: BoxFit.scaleDown, alignment: AlignmentDirectional.centerEnd, child: value),
            ),
          ],
        ),
      ),
    );
  }
}

/// A section without data: one line, centred, on its own card (16 / 32
/// padding, so 84 high).
class _InlineEmptyCard extends StatelessWidget {
  const _InlineEmptyCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xxl),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: MasroofyColors.of(context).textSecondary),
          ),
        ),
      ),
    );
  }
}

/// All wallets: each wallet's spending and income for the period, with a thin
/// bar for its share of the spending, and its transfers.
class _WalletBreakdown extends StatelessWidget {
  const _WalletBreakdown({required this.state});

  final AnalyticsState state;

  @override
  Widget build(BuildContext context) {
    final totalSpent = state.totals.spent;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (index, wallet) in state.wallets.indexed) ...[
            if (index > 0) const Divider(),
            _WalletRow(
              wallet: wallet,
              totals: state.byWallet[wallet.id] ?? PeriodTotals.zero,
              share: totalSpent.isPositive ? (state.byWallet[wallet.id]?.spent.minor ?? 0) / totalSpent.minor : 0,
            ),
          ],
        ],
      ),
    );
  }
}

/// Figma "Legend Row" of the By wallet card: a 40 avatar (24 glyph), then the
/// name and spending, a 120 × 6 share bar with the income at the end, and a
/// small line per direction of transfer. 70 high, 88 with one transfers line.
class _WalletRow extends StatelessWidget {
  const _WalletRow({required this.wallet, required this.totals, required this.share});

  final Wallet wallet;
  final PeriodTotals totals;

  /// This wallet's part of all spending, 0 to 1.
  final double share;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final income = totals.income;

    Widget transferLine(String line) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          line,
          textAlign: TextAlign.end,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.bodySmall!.copyWith(color: colors.textSecondary),
        ),
      ),
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 70),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            WalletAvatar(icon: wallet.icon, color: wallet.color, iconSize: 24),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          wallet.displayName,
                          textDirection: wallet.nameDirection,
                          style: text.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(context.money(totals.spent), style: text.titleMedium),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Container(
                        width: 120,
                        height: 6,
                        decoration: ShapeDecoration(shape: const StadiumBorder(), color: colors.track),
                        child: FractionallySizedBox(
                          alignment: AlignmentDirectional.centerStart,
                          widthFactor: share.clamp(0, 1).toDouble(),
                          child: DecoratedBox(
                            decoration: ShapeDecoration(shape: const StadiumBorder(), color: Color(wallet.color)),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          StringManager.walletIn(context.signedMoney(income)),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelMedium!.copyWith(
                            color: income.isPositive ? colors.textPositive : colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (totals.transfersIn.isPositive)
                    transferLine(StringManager.walletTransfersIn(context.signedMoney(totals.transfersIn))),
                  if (totals.transfersOut.isPositive)
                    transferLine(StringManager.walletTransfersOut(context.signedMoney(-totals.transfersOut))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The Spending | Income control, then the donut with every category and its
/// share, largest first, on one card; or one inline line when there is none.
class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.state});

  final AnalyticsState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnalyticsCubit>();
    final total = state.breakdownTotal;
    // Figma: the control sits above the card, not inside it.
    return Column(
      children: [
        SegmentedPills(
          labels: [StringManager.analyticsSpending, StringManager.analyticsIncome],
          selected: state.breakdownKind.index,
          onSelected: (i) => cubit.selectBreakdown(TransactionKind.values[i]),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (state.byCategory.isEmpty)
          _InlineEmptyCard(
            message: state.breakdownKind == TransactionKind.income
                ? StringManager.noIncomeData
                : StringManager.noSpendingInPeriod,
          )
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: SpendingPieChart(slices: state.slices, categories: state.categories, total: total),
                ),
                for (final (category, amount) in state.legend) ...[
                  const Divider(indent: 72),
                  _LegendRow(category: category, amount: amount, total: total),
                ],
              ],
            ),
          ),
      ],
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
