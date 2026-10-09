import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';

part 'recurring_draft.freezed.dart';

/// The user-editable fields of a recurring template, as entered in the form.
@freezed
abstract class RecurringDraft with _$RecurringDraft {
  const factory RecurringDraft({
    required String title,
    required Money amount,
    required int categoryId,
    required RecurringFrequency frequency,

    /// May be in the past (back-fills, within the cap) or the future.
    required LocalDate startDate,
    @Default(true) bool isActive,

    /// What the form is set to; the category must be of this kind.
    @Default(TransactionKind.expense) TransactionKind kind,
  }) = _RecurringDraft;
}
