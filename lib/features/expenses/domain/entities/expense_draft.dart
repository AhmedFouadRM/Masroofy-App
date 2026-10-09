import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';

part 'expense_draft.freezed.dart';

/// The user-editable fields of an expense, as entered in the form.
@freezed
abstract class ExpenseDraft with _$ExpenseDraft {
  const factory ExpenseDraft({
    required Money amount,
    required int walletId,
    required int categoryId,
    required LocalDate date,

    /// Null when the user left it empty; the UI then shows the category name.
    String? title,
    String? note,

    /// What the form is set to; the category must be of this kind.
    @Default(TransactionKind.expense) TransactionKind kind,

    /// Where the row comes from. Only used when creating; an edit keeps the
    /// row's source.
    @Default(ExpenseSource.manual) ExpenseSource source,
  }) = _ExpenseDraft;
}
