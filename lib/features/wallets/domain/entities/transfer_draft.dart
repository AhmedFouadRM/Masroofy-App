import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';

part 'transfer_draft.freezed.dart';

/// The user-editable fields of a transfer, as entered in the form.
@freezed
abstract class TransferDraft with _$TransferDraft {
  const factory TransferDraft({
    required int fromWalletId,
    required int toWalletId,
    required Money amount,
    required LocalDate date,
    String? note,
  }) = _TransferDraft;
}
