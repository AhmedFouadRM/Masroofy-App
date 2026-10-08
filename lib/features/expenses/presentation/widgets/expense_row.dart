import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/shared/categories/category_avatar.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Figma "Expense Row": category avatar, title (or the category name),
/// category · note, and the amount with an optional recurring badge.
class ExpenseRow extends StatelessWidget {
  const ExpenseRow({required this.expense, required this.category, this.onTap, super.key});

  final Expense expense;

  /// Null only if the category vanished mid-update.
  final Category? category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final category = this.category;
    final categoryName = category?.displayName ?? '';
    // Untitled rows already show the category as their title.
    final subtitle = [
      if (expense.title != null) categoryName,
      ?expense.note,
    ].join(' · ');

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
                  Text(
                    expense.title ?? categoryName,
                    style: text.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: text.bodySmall!.copyWith(color: colors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(context.money(expense.amount), style: text.titleMedium),
                if (expense.isRecurringGenerated)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Symbols.repeat_rounded, size: 14, color: colors.textAccent),
                      const SizedBox(width: AppSpacing.xs),
                      Text(StringManager.recurringBadge, style: text.labelMedium!.copyWith(color: colors.textAccent)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
