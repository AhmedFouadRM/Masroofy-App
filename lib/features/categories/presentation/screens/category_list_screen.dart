import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/categories/domain/entities/category_summary.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:masroofy/features/categories/presentation/widgets/delete_category_dialog.dart';
import 'package:masroofy/shared/categories/category_avatar.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/glowing_fab.dart';
import 'package:masroofy/shared/widgets/grouped_list.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Settings → Manage Categories. Expects a [CategoriesCubit] above it.
class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesCubit, CategoriesState>(
      listenWhen: (previous, current) =>
          current.actionFailure != null && previous.actionFailure != current.actionFailure,
      listener: (context, state) => ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(StringManager.failure(state.actionFailure!)))),
      child: AuraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(title: Text(StringManager.categoriesTitle)),
          floatingActionButton: GlowingFab(
            tooltip: StringManager.addCategory,
            onPressed: () => context.push(RoutePaths.newCategory),
          ),
          body: BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) => switch (state.status) {
              CategoriesStatus.loading => const Center(child: CircularProgressIndicator.adaptive()),
              CategoriesStatus.failure => Center(child: Text(StringManager.failure(state.loadFailure!))),
              CategoriesStatus.loaded => _CategoryList(state: state),
            },
          ),
        ),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.state});

  final CategoriesState state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Bottom space keeps the last row clear of the FAB.
      padding: EdgeInsets.fromLTRB(AppSpacing.screen, MediaQuery.paddingOf(context).top, AppSpacing.screen, 96),
      children: [
        SectionHeader(title: StringManager.categoriesDefaultSection, trailing: context.count(state.defaults.length)),
        GroupedCard(children: [for (final s in state.defaults) _CategoryRow(summary: s)]),
        if (state.custom.isNotEmpty) ...[
          SectionHeader(title: StringManager.categoriesCustomSection, trailing: context.count(state.custom.length)),
          GroupedCard(children: [for (final s in state.custom) _DismissibleCategoryRow(summary: s)]),
        ],
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.summary, this.onTap});

  final CategorySummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final category = summary.category;
    final budget = summary.budgetLimit;
    final subtitle = [
      StringManager.categoryExpenseCount(summary.expenseCount, context.count(summary.expenseCount)),
      if (summary.recurringCount > 0)
        StringManager.categoryRecurringCount(summary.recurringCount, context.count(summary.recurringCount)),
      if (budget != null) StringManager.categoryBudget(context.money(budget)),
    ].join(' · ');

    return ListTile(
      leading: CategoryAvatar(icon: category.icon, color: category.color),
      title: Text(category.displayName),
      subtitle: Text(subtitle),
      trailing: onTap == null
          ? null
          : Icon(Symbols.chevron_forward_rounded, color: MasroofyColors.of(context).textSecondary),
      onTap: onTap,
    );
  }
}

/// A custom category: tap to edit, swipe towards the start to delete.
class _DismissibleCategoryRow extends StatelessWidget {
  const _DismissibleCategoryRow({required this.summary});

  final CategorySummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final id = summary.category.id;
    return Dismissible(
      key: ValueKey(id),
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
        final cubit = context.read<CategoriesCubit>();
        if (!await showDeleteCategoryDialog(context, summary)) return false;
        // The cubit drops the row at once, so the dismissal can complete.
        unawaited(cubit.delete(id));
        return true;
      },
      child: _CategoryRow(summary: summary, onTap: () => context.push(RoutePaths.editCategory(id))),
    );
  }
}
