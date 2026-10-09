import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_cubit.dart';
import 'package:masroofy/features/expenses/presentation/widgets/expense_row.dart';
import 'package:masroofy/shared/categories/category_chip.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/categories/category_icon_registry.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/widgets/app_shell.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/empty_state_widget.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/grouped_list.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
import 'package:masroofy/shared/widgets/summary_card.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Home: the expense feed. Expects an [ExpenseListCubit] above it.
class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final _search = TextEditingController();
  bool _searching = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() => _searching = !_searching);
    if (!_searching && _search.text.isNotEmpty) {
      _search.clear();
      context.read<ExpenseListCubit>().searchChanged('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpenseListCubit>();
    return BlocListener<ExpenseListCubit, ExpenseListState>(
      listenWhen: (previous, current) =>
          current.actionFailure != null && previous.actionFailure != current.actionFailure,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(StringManager.failure(state.actionFailure!)))),
      child: AuraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(
            title: _searching
                ? TextField(
                    controller: _search,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onChanged: cubit.searchChanged,
                    decoration: InputDecoration(
                      hintText: StringManager.searchExpensesHint,
                      prefixIcon: const Icon(Symbols.search_rounded),
                      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.full))),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.full)),
                        borderSide: BorderSide(color: MasroofyColors.of(context).border),
                      ),
                    ),
                  )
                : Text(StringManager.expensesTitle),
            actions: [
              IconButton(
                icon: Icon(_searching ? Symbols.close_rounded : Symbols.search_rounded),
                tooltip: _searching ? StringManager.closeSearch : StringManager.search,
                onPressed: _toggleSearch,
              ),
              if (!_searching)
                IconButton(
                  icon: const Icon(Symbols.repeat_rounded),
                  tooltip: StringManager.recurringTitle,
                  onPressed: () => context.push(RoutePaths.recurring),
                ),
              const SizedBox(width: AppSpacing.xs),
            ],
          ),
          body: BlocBuilder<ExpenseListCubit, ExpenseListState>(
            builder: (context, state) => NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.extentAfter < 600) cubit.loadMore();
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screen,
                      MediaQuery.paddingOf(context).top + AppSpacing.sm,
                      AppSpacing.screen,
                      0,
                    ),
                    sliver: SliverList.list(
                      children: [
                        _Summary(state: state),
                        const SizedBox(height: AppSpacing.lg),
                        _PeriodPills(state: state),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: _CategoryFilter(state: state)),
                  ..._content(context, state),
                  const SliverPadding(padding: EdgeInsets.only(bottom: AppShell.bottomInset + AppShell.fabInset)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context, ExpenseListState state) {
    final cubit = context.read<ExpenseListCubit>();
    switch (state.status) {
      case ExpenseListStatus.loading when state.loaded.isEmpty:
        return [
          const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator.adaptive())),
        ];
      case ExpenseListStatus.failure:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text(StringManager.failure(state.loadFailure!))),
          ),
        ];
      case _ when state.expenses.isEmpty:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: state.kind == TransactionKind.income && !state.isFiltered
                ? EmptyStateWidget(
                    icon: Symbols.payments_rounded,
                    title: StringManager.emptyIncome,
                    message: StringManager.emptyIncomeHint,
                    actionLabel: StringManager.addIncome,
                    actionIcon: Symbols.add_rounded,
                    onAction: () => context.push(RoutePaths.newIncome),
                  )
                : state.isFiltered
                ? EmptyStateWidget(
                    icon: Symbols.search_off_rounded,
                    title: StringManager.noMatchingExpenses,
                    actionLabel: StringManager.clearFilters,
                    onAction: () {
                      _search.clear();
                      setState(() => _searching = false);
                      cubit.clearFilters();
                    },
                  )
                : EmptyStateWidget(
                    icon: Symbols.receipt_long_rounded,
                    // With All selected the list holds income too.
                    title: state.kind == null ? StringManager.emptyTransactions : StringManager.emptyExpenses,
                    message: state.kind == null ? StringManager.emptyTransactionsHint : StringManager.emptyExpensesHint,
                    actionLabel: StringManager.addFirstExpense,
                    actionIcon: Symbols.add_rounded,
                    onAction: () => context.push(RoutePaths.newExpense),
                  ),
          ),
        ];
      case _:
        final days = _groupByDay(state.expenses);
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            sliver: SliverList.builder(
              itemCount: days.length,
              itemBuilder: (context, i) => _DaySection(day: days[i].$1, expenses: days[i].$2, state: state),
            ),
          ),
        ];
    }
  }

  static List<(LocalDate, List<Expense>)> _groupByDay(List<Expense> expenses) {
    final days = <(LocalDate, List<Expense>)>[];
    for (final expense in expenses) {
      if (days.isEmpty || days.last.$1 != expense.date) days.add((expense.date, []));
      days.last.$2.add(expense);
    }
    return days;
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.state});

  final ExpenseListState state;

  @override
  Widget build(BuildContext context) {
    final range = _rangeLabel(context, state.range);
    final totals = state.visibleTotals;
    final comparison = switch (state.period) {
      ExpensePeriod.week => StringManager.vsLastWeek,
      ExpensePeriod.month => StringManager.vsLastMonth,
      ExpensePeriod.custom => StringManager.vsPreviousPeriod,
    };
    return switch (state.kind) {
      // The balance, with what came in and went out.
      null => SummaryCard(
        label: switch (state.period) {
          ExpensePeriod.week => StringManager.leftThisWeek,
          ExpensePeriod.month => StringManager.leftThisMonth,
          ExpensePeriod.custom => StringManager.leftInRange(range),
        },
        total: totals.balance,
        signed: true,
        details: [
          (label: StringManager.incomeIn, amount: totals.income),
          (label: StringManager.incomeOut, amount: totals.spent),
        ],
      ),
      TransactionKind.expense => SummaryCard(
        label: switch (state.period) {
          ExpensePeriod.week => StringManager.spentThisWeek,
          ExpensePeriod.month => StringManager.spentThisMonth,
          ExpensePeriod.custom => StringManager.spentInRange(range),
        },
        total: totals.spent,
        previousTotal: state.previousTotals?.spent,
        comparisonLabel: comparison,
      ),
      TransactionKind.income => SummaryCard(
        label: switch (state.period) {
          ExpensePeriod.week => StringManager.earnedThisWeek,
          ExpensePeriod.month => StringManager.earnedThisMonth,
          ExpensePeriod.custom => StringManager.earnedInRange(range),
        },
        total: totals.income,
        previousTotal: state.previousTotals?.income,
        comparisonLabel: comparison,
      ),
    };
  }
}

String _rangeLabel(BuildContext context, DateRange range) =>
    '${context.shortDate(range.start)} – ${context.shortDate(range.end)}';

class _PeriodPills extends StatelessWidget {
  const _PeriodPills({required this.state});

  final ExpenseListState state;

  Future<void> _pickRange(BuildContext context) async {
    final cubit = context.read<ExpenseListCubit>();
    final today = LocalDate.today();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: today.toDateTime(),
      initialDateRange: DateTimeRange(start: state.range.start.toDateTime(), end: state.range.end.toDateTime()),
    );
    if (picked == null) return;
    cubit.selectCustomRange(DateRange(LocalDate.fromDateTime(picked.start), LocalDate.fromDateTime(picked.end)));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpenseListCubit>();
    return SegmentedPills(
      labels: [
        StringManager.thisWeek,
        StringManager.thisMonth,
        if (state.period == ExpensePeriod.custom) _rangeLabel(context, state.range) else StringManager.customRange,
      ],
      selected: state.period.index,
      onSelected: (i) => switch (ExpensePeriod.values[i]) {
        ExpensePeriod.custom => _pickRange(context),
        final period => cubit.selectPeriod(period),
      },
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.state});

  final ExpenseListState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ExpenseListCubit>();
    final colors = MasroofyColors.of(context);
    final categories = state.filterCategories;
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen, vertical: AppSpacing.md),
        itemCount: categories.length + 3,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          // All · Income · Expenses, then the categories of the selected kind.
          if (i < 3) {
            final (kind, label, icon) = switch (i) {
              0 => (null, StringManager.allCategories, Symbols.apps_rounded),
              1 => (TransactionKind.income, StringManager.filterIncome, Symbols.trending_up_rounded),
              _ => (TransactionKind.expense, StringManager.filterExpenses, Symbols.trending_down_rounded),
            };
            return CategoryChip(
              label: label,
              icon: icon,
              iconColor: colors.textAccent,
              selected: state.kind == kind,
              onTap: () => cubit.selectKind(kind),
            );
          }
          final category = categories[i - 3];
          return CategoryChip(
            label: category.displayName,
            icon: CategoryIconRegistry.of(category.icon),
            iconColor: Color(category.color),
            selected: state.categoryId == category.id,
            onTap: () => cubit.selectCategory(state.categoryId == category.id ? null : category.id),
          );
        },
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.day, required this.expenses, required this.state});

  final LocalDate day;
  final List<Expense> expenses;
  final ExpenseListState state;

  void _delete(BuildContext context, Expense expense) {
    final cubit = context.read<ExpenseListCubit>()..hide(expense.id);
    final title = expense.title ?? state.categories[expense.categoryId]?.displayName ?? '';
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    final snackBar = messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(StringManager.expenseDeleted(title)),
        action: SnackBarAction(label: StringManager.undo, onPressed: () {}),
      ),
    );
    // The undo window ends when the snackbar closes for any other reason.
    unawaited(
      snackBar.closed.then((reason) async {
        if (reason == SnackBarClosedReason.action) {
          cubit.undoDelete(expense.id);
        } else {
          await cubit.commitDelete(expense.id);
        }
      }),
    );
  }

  /// All: the day's net with a sign. Expenses: what was spent. Income: what came in.
  String _dayTotal(BuildContext context, PeriodTotals totals) => switch (state.kind) {
    null => context.signedMoney(totals.balance),
    TransactionKind.expense => context.money(totals.spent),
    TransactionKind.income => context.signedMoney(totals.income),
  };

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Column(
      children: [
        SectionHeader(
          title: context.dayLabel(day, today: LocalDate.today()),
          trailing: _dayTotal(context, state.dayTotals(day)),
        ),
        GroupedCard(
          children: [
            for (final expense in expenses)
              Dismissible(
                key: ValueKey(expense.id),
                // Toward the start edge; flips in Arabic.
                direction: DismissDirection.endToStart,
                background: ColoredBox(
                  color: colors.negative,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(end: AppSpacing.xl),
                      child: Icon(Symbols.delete_rounded, color: colors.onPrimary, semanticLabel: StringManager.delete),
                    ),
                  ),
                ),
                onDismissed: (_) => _delete(context, expense),
                child: ExpenseRow(
                  expense: expense,
                  category: state.categories[expense.categoryId],
                  onTap: () => context.push(RoutePaths.editExpense(expense.id)),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
