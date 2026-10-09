import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/catch_up_candidate.dart';
import 'package:masroofy/features/sms_import/presentation/cubits/sms_import_cubit.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/widgets/glass_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Opens the catch-up review ("Import the last 30 days?") over the screen of
/// [cubit], which must already be scanning. Resolves to how many transactions
/// were added, or null when the sheet was skipped or dismissed.
Future<int?> showCatchUpSheet(BuildContext context, SmsImportCubit cubit) => showGlassSheet<int>(
  context,
  title: StringManager.smsCatchUpTitle,
  builder: (context) => BlocProvider.value(value: cubit, child: const _CatchUpSheet()),
);

class _CatchUpSheet extends StatelessWidget {
  const _CatchUpSheet();

  @override
  Widget build(BuildContext context) {
    final catchUp = context.select<SmsImportCubit, CatchUpState?>((cubit) => cubit.state.catchUp);
    if (catchUp == null) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;
    final colors = MasroofyColors.of(context);

    return switch (catchUp.status) {
      CatchUpStatus.scanning => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator.adaptive(),
            const SizedBox(height: AppSpacing.md),
            Text(StringManager.smsCatchUpScanning, style: text.bodyMedium!.copyWith(color: colors.textSecondary)),
          ],
        ),
      ),
      CatchUpStatus.failed => _Message(text: StringManager.smsCatchUpFailed),
      CatchUpStatus.ready when catchUp.candidates.isEmpty => _Message(text: StringManager.smsCatchUpEmpty),
      CatchUpStatus.ready || CatchUpStatus.adding => _Review(catchUp: catchUp),
    };
  }
}

/// A line of text with a Skip button under it.
class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: MasroofyColors.of(context).textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextButton(onPressed: () => Navigator.pop(context), child: Text(StringManager.smsCatchUpSkip)),
      ],
    );
  }
}

class _Review extends StatelessWidget {
  const _Review({required this.catchUp});

  final CatchUpState catchUp;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SmsImportCubit>();
    final text = Theme.of(context).textTheme;
    final colors = MasroofyColors.of(context);
    final adding = catchUp.status == CatchUpStatus.adding;
    final count = catchUp.selectedCount;
    final smsState = context.select<SmsImportCubit, SmsImportState>((cubit) => cubit.state);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          StringManager.smsCatchUpFound(catchUp.candidates.length, context.count(catchUp.candidates.length)),
          style: text.bodyMedium!.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.sm),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              for (final candidate in catchUp.candidates)
                _CandidateRow(
                  candidate: candidate,
                  title: candidate.parsed.merchant ?? smsState.category(candidate.categoryId)?.displayName ?? '',
                  checked: catchUp.selected.contains(candidate.smsKey),
                  onToggle: adding ? null : () => cubit.toggleCandidate(candidate.smsKey),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton(
          onPressed: adding || count == 0 ? null : () => unawaited(_add(context, cubit)),
          child: adding
              ? SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: colors.onPrimary),
                )
              : Text(StringManager.smsCatchUpAdd(context.count(count))),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextButton(
          onPressed: adding ? null : () => Navigator.pop(context),
          child: Text(StringManager.smsCatchUpSkip),
        ),
      ],
    );
  }

  Future<void> _add(BuildContext context, SmsImportCubit cubit) async {
    final navigator = Navigator.of(context);
    final added = await cubit.addSelected();
    if (added != null) navigator.pop(added);
  }
}

/// A checkbox, the merchant, "Oct 9 · Expense", the amount and, for a likely
/// duplicate, the "Possible duplicate" note.
class _CandidateRow extends StatelessWidget {
  const _CandidateRow({required this.candidate, required this.title, required this.checked, required this.onToggle});

  final CatchUpCandidate candidate;
  final String title;
  final bool checked;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final parsed = candidate.parsed;
    final income = parsed.kind.transactionKind == TransactionKind.income;
    final bank = SenderCatalog.displayName(candidate.sender);
    final title = this.title.isEmpty ? bank : this.title;
    final label = '${context.shortDate(parsed.date)} · ${StringManager.kindLabel(parsed.kind.transactionKind)}';
    final amount = income ? context.signedMoney(parsed.amount) : context.money(parsed.amount);

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(AppRadius.input),
      child: Semantics(
        checked: checked,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Checkbox(
                  value: checked,
                  onChanged: onToggle == null ? null : (_) => onToggle!(),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text(label, style: text.bodySmall!.copyWith(color: colors.textSecondary)),
                    if (candidate.likelyDuplicate)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Symbols.content_copy_rounded, size: 14, color: colors.textWarning),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: Text(
                                StringManager.smsPossibleDuplicate,
                                style: text.labelMedium!.copyWith(color: colors.textWarning),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(amount, style: income ? text.titleMedium!.copyWith(color: colors.textPositive) : text.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
