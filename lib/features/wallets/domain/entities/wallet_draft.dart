import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_draft.freezed.dart';

/// The user-editable fields of a wallet, as typed in the form.
@freezed
abstract class WalletDraft with _$WalletDraft {
  const factory WalletDraft({
    required String icon,
    required int color,

    /// Null keeps the seeded name of "Me" as it is (translated); required for
    /// every other wallet.
    String? name,
  }) = _WalletDraft;
}
