import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/categories/domain/entities/category_summary.dart';
import 'package:masroofy/features/categories/presentation/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';

/// Asks before deleting a custom category, saying what moves to Other.
/// Resolves to `true` when the user confirms.
Future<bool> showDeleteCategoryDialog(BuildContext context, CategorySummary summary) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      final colors = MasroofyColors.of(context);
      return AlertDialog(
        title: Text(StringManager.deleteCategoryTitle(summary.category.displayName)),
        content: Text(
          StringManager.deleteCategoryBody(
            expenses: summary.expenseCount,
            expensesNumber: context.count(summary.expenseCount),
            templates: summary.recurringCount,
            templatesNumber: context.count(summary.recurringCount),
            hasBudget: summary.budgetLimit != null,
          ),
        ),
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
