import 'package:flutter/material.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/shared/categories/category_avatar.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';

/// A row of Recent imports (Figma "Expense Row" with a status chip): the
/// category avatar, the merchant, "CIB ••1234 · Oct 9", the amount and the
/// status.
class SmsImportRow extends StatelessWidget {
  const SmsImportRow({required this.import, required this.category, this.onTap, super.key});

  final SmsImport import;

  /// Null when the category was deleted since.
  final Category? category;
  final VoidCallback? onTap;

  /// The amount as the row shows it: in the app currency like every amount,
  /// else with the currency the message used.
  static String amountText(BuildContext context, SmsImport import) {
    final income = import.kind == TransactionKind.income;
    if (import.currency != context.currency.code) return '${import.currency} ${context.amount(import.amount)}';
    return income ? context.signedMoney(import.amount) : context.money(import.amount);
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final bank = SenderCatalog.displayName(import.sender);
    final account = import.cardLast4 == null ? bank : '$bank ••${import.cardLast4}';
    final title = import.merchant ?? category?.displayName ?? bank;
    final income = import.kind == TransactionKind.income && import.currency == context.currency.code;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            CategoryAvatar(
              icon: category?.icon ?? 'more_horiz',
              color: category?.color ?? colors.textSecondary.toARGB32(),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: text.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // A merchant's name is whatever the SMS said, often Latin.
                    textDirection: import.merchant == null ? null : _directionOf(import.merchant!),
                  ),
                  Text(
                    context.digits('$account · ${context.shortDate(import.date)}'),
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
                Text(
                  amountText(context, import),
                  style: income ? text.titleMedium!.copyWith(color: colors.textPositive) : text.titleMedium,
                ),
                const SizedBox(height: 2),
                SmsStatusChip(status: import.status),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Right to left only when the name has Arabic letters.
  static TextDirection _directionOf(String name) =>
      RegExp('[\u0600-\u06FF]').hasMatch(name) ? TextDirection.rtl : TextDirection.ltr;
}

/// Added, Needs review, Ignored or Cancelled, as a small pill.
class SmsStatusChip extends StatelessWidget {
  const SmsStatusChip({required this.status, super.key});

  final SmsImportStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final (background, foreground) = switch (status) {
      SmsImportStatus.added => (colors.primarySubtle, colors.textAccent),
      SmsImportStatus.pending => (colors.warning.withValues(alpha: 0.18), colors.textWarning),
      SmsImportStatus.ignored || SmsImportStatus.cancelled => (colors.surfaceVariant, colors.textSecondary),
    };
    return DecoratedBox(
      decoration: ShapeDecoration(shape: const StadiumBorder(), color: background),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
        child: Text(
          StringManager.smsStatus(status.name),
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: foreground),
        ),
      ),
    );
  }
}
