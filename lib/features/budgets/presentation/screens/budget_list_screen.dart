import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_list_cubit.dart';
import 'package:masroofy/shared/budgets/budget_progress_row.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/empty_state_widget.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/glowing_fab.dart';
import 'package:masroofy/shared/widgets/grouped_list.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Settings → Manage Budgets. Expects a [BudgetListCubit] above it.
class BudgetListScreen extends StatelessWidget {
  const BudgetListScreen({super.key});

  void _showHint(BuildContext context, String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetListCubit, BudgetListState>(
      listenWhen: (previous, current) =>
          current.actionFailure != null && previous.actionFailure != current.actionFailure,
      listener: (context, state) => _showHint(context, StringManager.failure(state.actionFailure!)),
      child: AuraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(title: Text(StringManager.budgetsTitle)),
          floatingActionButton: BlocBuilder<BudgetListCubit, BudgetListState>(
            builder: (context, state) {
              // The empty state has its own add button.
              if (state.status != BudgetListStatus.loaded || state.budgets.isEmpty) return const SizedBox.shrink();
              if (state.allBudgeted) {
                final colors = MasroofyColors.of(context);
                // Muted, and explains itself when tapped.
                return FloatingActionButton(
                  tooltip: StringManager.allCategoriesBudgeted,
                  backgroundColor: colors.surfaceVariant,
                  foregroundColor: colors.textSecondary,
                  onPressed: () => _showHint(context, StringManager.allCategoriesBudgeted),
                  child: const Icon(Symbols.add_rounded),
                );
              }
              return GlowingFab(tooltip: StringManager.addBudget, onPressed: () => context.push(RoutePaths.newBudget));
            },
          ),
          body: BlocBuilder<BudgetListCubit, BudgetListState>(
            builder: (context, state) => switch (state.status) {
              BudgetListStatus.loading => const Center(child: CircularProgressIndicator.adaptive()),
              BudgetListStatus.failure => Center(child: Text(StringManager.failure(state.loadFailure!))),
              BudgetListStatus.loaded when state.budgets.isEmpty => Padding(
                // The body runs under the glass app bar.
                padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                child: Center(
                  child: EmptyStateWidget(
                    icon: Symbols.savings_rounded,
                    title: StringManager.emptyBudgets,
                    message: StringManager.emptyBudgetsHint,
                    actionLabel: StringManager.addFirstBudget,
                    actionIcon: Symbols.add_rounded,
                    onAction: () => context.push(RoutePaths.newBudget),
                  ),
                ),
              ),
              BudgetListStatus.loaded => ListView(
                // Bottom space keeps the last row clear of the FAB.
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  MediaQuery.paddingOf(context).top + AppSpacing.sm,
                  AppSpacing.screen,
                  96,
                ),
                children: [
                  GroupedCard(
                    children: [for (final b in state.budgets) _DismissibleRow(progress: b, state: state)],
                  ),
                ],
              ),
            },
          ),
        ),
      ),
    );
  }
}

/// Tap to edit, swipe towards the start to delete (after a confirmation).
class _DismissibleRow extends StatelessWidget {
  const _DismissibleRow({required this.progress, required this.state});

  final BudgetProgress progress;
  final BudgetListState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BudgetListCubit>();
    final colors = MasroofyColors.of(context);
    final budget = progress.budget;
    final category = state.categories[budget.categoryId];
    return Dismissible(
      key: ValueKey(budget.id),
      // Relative to the text direction, so it flips in Arabic.
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
      confirmDismiss: (_) async {
        if (!await _confirmDelete(context, category?.displayName ?? '')) return false;
        // The cubit drops the row at once, so the dismissal can complete.
        unawaited(cubit.delete(budget.id));
        return true;
      },
      child: BudgetProgressRow(
        progress: progress,
        category: category,
        periodLabel: StringManager.budgetPeriod(budget.period.name),
        onTap: () => context.push(RoutePaths.editBudget(budget.id)),
      ),
    );
  }
}

Future<bool> _confirmDelete(BuildContext context, String category) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colors = MasroofyColors.of(context);
      return AlertDialog(
        title: Text(StringManager.deleteBudgetTitle(category)),
        content: Text(StringManager.deleteBudgetBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(StringManager.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: colors.negative, foregroundColor: colors.onPrimary),
            onPressed: () => Navigator.pop(context, true),
            child: Text(StringManager.delete),
          ),
        ],
      );
    },
  );
  return confirmed ?? false;
}
