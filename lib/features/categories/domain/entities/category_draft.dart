import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';

part 'category_draft.freezed.dart';

/// The user-editable fields of a custom category, as typed in the form.
@freezed
abstract class CategoryDraft with _$CategoryDraft {
  const factory CategoryDraft({
    required String name,
    required String icon,
    required int color,
    @Default(TransactionKind.expense) TransactionKind kind,
  }) = _CategoryDraft;
}
