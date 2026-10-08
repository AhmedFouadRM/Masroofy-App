import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_list_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/widgets/recurring_row.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/empty_state_widget.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/glowing_fab.dart';
import 'package:masroofy/shared/widgets/grouped_list.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Expenses → Recurring. Expects a [RecurringListCubit] above it.
class RecurringListScreen extends StatelessWidget {
  const RecurringListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecurringListCubit, RecurringListState>(
      listenWhen: (previous, current) =>
          current.actionFailure != null && previous.actionFailure != current.actionFailure,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(StringManager.failure(state.actionFailure!)))),
      child: AuraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(title: Text(StringManager.recurringTitle)),
          floatingActionButton: BlocSelector<RecurringListCubit, RecurringListState, bool>(
            // The empty state has its own add button.
            selector: (state) => state.templates.isNotEmpty,
            builder: (context, show) => show
                ? GlowingFab(
                    tooltip: StringManager.addRecurring,
                    onPressed: () => context.push(RoutePaths.newRecurring),
                  )
                : const SizedBox.shrink(),
          ),
          body: BlocBuilder<RecurringListCubit, RecurringListState>(
            builder: (context, state) => switch (state.status) {
              RecurringListStatus.loading => const Center(child: CircularProgressIndicator.adaptive()),
              RecurringListStatus.failure => Center(child: Text(StringManager.failure(state.loadFailure!))),
              RecurringListStatus.loaded when state.templates.isEmpty => Padding(
                // The body runs under the glass app bar.
                padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                child: Center(
                  child: EmptyStateWidget(
                    icon: Symbols.event_repeat_rounded,
                    title: StringManager.emptyRecurring,
                    message: StringManager.emptyRecurringHint,
                    actionLabel: StringManager.addFirstRecurring,
                    actionIcon: Symbols.add_rounded,
                    onAction: () => context.push(RoutePaths.newRecurring),
                  ),
                ),
              ),
              RecurringListStatus.loaded => _TemplateList(state: state),
            },
          ),
        ),
      ),
    );
  }
}

class _TemplateList extends StatelessWidget {
  const _TemplateList({required this.state});

  final RecurringListState state;

  @override
  Widget build(BuildContext context) {
    final active = state.active;
    final paused = state.paused;
    return ListView(
      // Bottom space keeps the last row clear of the FAB.
      padding: EdgeInsets.fromLTRB(AppSpacing.screen, MediaQuery.paddingOf(context).top, AppSpacing.screen, 96),
      children: [
        if (active.isNotEmpty) ...[
          SectionHeader(title: StringManager.recurringActiveSection, trailing: context.count(active.length)),
          GroupedCard(
            children: [for (final t in active) _DismissibleRow(template: t, state: state)],
          ),
        ],
        if (paused.isNotEmpty) ...[
          SectionHeader(title: StringManager.recurringPausedSection, trailing: context.count(paused.length)),
          GroupedCard(
            children: [for (final t in paused) _DismissibleRow(template: t, state: state)],
          ),
        ],
      ],
    );
  }
}

/// Tap to edit, flip the switch to pause or resume, swipe towards the start
/// to delete (after a confirmation).
class _DismissibleRow extends StatelessWidget {
  const _DismissibleRow({required this.template, required this.state});

  final RecurringExpense template;
  final RecurringListState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecurringListCubit>();
    final colors = MasroofyColors.of(context);
    return Dismissible(
      key: ValueKey(template.id),
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
        if (!await _confirmDelete(context, template)) return false;
        // The cubit drops the row at once, so the dismissal can complete.
        unawaited(cubit.delete(template.id));
        return true;
      },
      child: RecurringRow(
        template: template,
        category: state.categories[template.categoryId],
        onTap: () => context.push(RoutePaths.editRecurring(template.id)),
        onActiveChanged: (active) => unawaited(cubit.setActive(template.id, active: active)),
      ),
    );
  }
}

Future<bool> _confirmDelete(BuildContext context, RecurringExpense template) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colors = MasroofyColors.of(context);
      return AlertDialog(
        title: Text(StringManager.deleteRecurringTitle(template.title)),
        content: Text(StringManager.deleteRecurringBody),
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
