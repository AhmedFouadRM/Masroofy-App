import 'package:flutter/material.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';
import 'package:masroofy/shared/categories/category_avatar.dart';
import 'package:masroofy/shared/formatting/display_format.dart';

/// Figma "Recurring Row": category avatar, title, frequency
/// and next due date, the amount, and the active switch.
class RecurringRow extends StatelessWidget {
  const RecurringRow({
    required this.template,
    required this.category,
    required this.onActiveChanged,
    this.onTap,
    super.key,
  });

  final RecurringExpense template;

  /// Null only if the category vanished mid-update.
  final Category? category;
  final ValueChanged<bool> onActiveChanged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final category = this.category;
    final active = template.isActive;
    final subtitle = [
      StringManager.frequency(template.frequency.name),
      if (active) StringManager.nextDue(_dueLabel(context)) else StringManager.recurringPaused,
    ].join(' · ');

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(AppSpacing.lg, AppSpacing.md, AppSpacing.sm, AppSpacing.md),
        child: Row(
          children: [
            if (category != null)
              Opacity(
                opacity: active ? 1 : 0.5,
                child: CategoryAvatar(icon: category.icon, color: category.color),
              ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.title,
                    style: text.bodyLarge!.copyWith(color: active ? null : colors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: text.bodySmall!.copyWith(color: colors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              context.money(template.amount),
              style: text.titleMedium!.copyWith(color: active ? null : colors.textSecondary),
            ),
            const SizedBox(width: AppSpacing.sm),
            Semantics(
              label: StringManager.recurringActiveToggle(template.title),
              child: Switch(value: active, onChanged: onActiveChanged),
            ),
          ],
        ),
      ),
    );
  }

  String _dueLabel(BuildContext context) {
    final today = LocalDate.today();
    final due = template.nextDueDate;
    if (due == today) return StringManager.today;
    return due.year == today.year ? context.shortDate(due) : context.longDate(due);
  }
}
