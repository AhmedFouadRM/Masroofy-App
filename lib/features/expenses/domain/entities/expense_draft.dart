import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';

part 'expense_draft.freezed.dart';

/// The user-editable fields of an expense, as entered in the form.
@freezed
abstract class ExpenseDraft with _$ExpenseDraft {
  const factory ExpenseDraft({
    required Money amount,
    required int categoryId,
    required LocalDate date,

    /// Null when the user left it empty; the UI then shows the category name.
    String? title,
    String? note,
  }) = _ExpenseDraft;
}
