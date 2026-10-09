import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/shared/categories/category_avatar.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Figma "Budget Bar": category and `spent / limit`, a bar coloured by
/// status, then the status line and the period (Budgets PRD → Visual
/// Feedback): safe < 80%, warning up to the limit, exceeded only when
/// spent > limit. Colour is never the only signal: the status line always
/// says what is left or how far over.
class BudgetProgressRow extends StatelessWidget {
  const BudgetProgressRow({
    required this.progress,
    required this.category,
    required this.periodLabel,
    this.onTap,
    super.key,
  });

  final BudgetProgress progress;

  /// Null only if the category vanished mid-update.
  final Category? category;

  /// E.g. "Monthly" in the budget list, "This month" in Analytics.
  final String periodLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final category = this.category;
    final (barColor, statusColor, statusIcon) = switch (progress.status) {
      BudgetStatus.safe => (colors.positive, colors.textPositive, Symbols.check_circle_rounded),
      BudgetStatus.warning => (colors.warning, colors.textWarning, Symbols.warning_rounded),
      BudgetStatus.exceeded => (colors.negative, colors.textNegative, Symbols.error_rounded),
    };
    final remaining = progress.remaining;
    final status = remaining.isNegative
        ? StringManager.overBudget(context.money(-remaining))
        : StringManager.budgetRemaining(context.money(remaining));

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (category != null) CategoryAvatar(icon: category.icon, color: category.color, size: 32),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    category?.displayName ?? '',
                    style: text.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${context.amount(progress.spent)} / ${context.amount(progress.budget.limit)}',
                  style: text.bodyMedium!.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Semantics(
              label: StringManager.budgetStatus(progress.status.name),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: progress.ratio.clamp(0, 1),
                  minHeight: 8,
                  color: barColor,
                  backgroundColor: colors.track,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(statusIcon, size: 16, color: statusColor),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    status,
                    style: text.labelMedium!.copyWith(color: statusColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(periodLabel, style: text.bodySmall!.copyWith(color: colors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
