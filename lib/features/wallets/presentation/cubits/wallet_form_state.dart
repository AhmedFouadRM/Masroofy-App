import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';

part 'wallet_form_state.freezed.dart';

enum WalletFormStatus { loading, ready, saving, saved, deleting, deleted, loadFailure }

@freezed
abstract class WalletFormState with _$WalletFormState {
  const factory WalletFormState({
    required String icon,
    required int color,
    @Default(WalletFormStatus.loading) WalletFormStatus status,

    /// Null for a new wallet.
    int? id,

    /// The name as typed. Empty for the seeded wallet until it is edited: its
    /// name comes from the translations, which the screen fills in.
    @Default('') String name,

    /// Whether the name was typed in; a seeded wallet's name is kept as it is
    /// until then.
    @Default(false) bool nameEdited,

    /// The wallet being edited.
    Wallet? wallet,

    /// The **Set as default** switch (edit mode only), and whether the wallet
    /// was the default when the form opened.
    @Default(false) bool makeDefault,
    @Default(false) bool wasDefault,

    /// Shown under the name field; cleared as soon as the user types.
    ValidationReason? nameError,

    /// A load, save or delete failure other than a name error.
    Failure? failure,

    /// Every wallet, for the delete dialog (where its rows can move to).
    @Default(<WalletSummary>[]) List<WalletSummary> wallets,
  }) = _WalletFormState;

  const WalletFormState._();

  bool get isEditing => id != null;

  /// A seeded wallet keeps its translated name until the user types one.
  bool get keepsSeedName => (wallet?.isSeeded ?? false) && !nameEdited;

  /// Usage of the wallet being edited, for the delete confirmation.
  WalletSummary? get usage => wallets.where((w) => w.wallet.id == id).firstOrNull;

  /// The wallet's rows and templates can move to these.
  List<WalletSummary> get others => [
    for (final w in wallets)
      if (w.wallet.id != id) w,
  ];

  /// The last wallet can't be deleted.
  bool get canDelete => isEditing && wallets.length > 1;

  bool get canSave => status == WalletFormStatus.ready && (keepsSeedName || name.trim().isNotEmpty);
}
