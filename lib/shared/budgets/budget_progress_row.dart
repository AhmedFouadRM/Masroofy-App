import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/shared/categories/category_avatar.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';

/// Figma "Budget Bar": category, spent of limit, and a bar coloured by
/// status (Budgets PRD → Visual Feedback): safe < 80%, warning up to the
/// limit, exceeded only when spent > limit.
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
    final status = progress.status;
    final (barColor, labelColor) = switch (status) {
      BudgetStatus.safe => (colors.positive, colors.textSecondary),
      BudgetStatus.warning => (colors.warning, colors.textSecondary),
      BudgetStatus.exceeded => (colors.negative, colors.textNegative),
    };
    final remaining = progress.remaining;
    final trailing = remaining.isNegative
        ? StringManager.overBudget(context.money(-remaining))
        : StringManager.budgetRemaining(context.money(remaining));

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            if (category != null) CategoryAvatar(icon: category.icon, color: category.color),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          category?.displayName ?? '',
                          style: text.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(trailing, style: text.labelMedium!.copyWith(color: labelColor)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Semantics(
                    label: StringManager.budgetStatus(status.name),
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
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '$periodLabel · ${StringManager.budgetOfLimit(context.money(progress.spent), context.money(progress.budget.limit))}',
                    style: text.bodySmall!.copyWith(color: colors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
