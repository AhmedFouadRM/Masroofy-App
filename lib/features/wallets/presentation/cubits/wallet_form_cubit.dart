import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/theme/app_colors.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_draft.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';
import 'package:masroofy/features/wallets/domain/usecases/delete_wallet.dart';
import 'package:masroofy/features/wallets/domain/usecases/save_wallet.dart';
import 'package:masroofy/features/wallets/domain/wallet_icons.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallet_form_state.dart';

export 'package:masroofy/features/wallets/presentation/cubits/wallet_form_state.dart';

/// New / Edit Wallet. Pass `walletId` to edit; `isDefault` says whether that
/// wallet is the default one (a preference the screen applies on save).
class WalletFormCubit extends Cubit<WalletFormState> {
  WalletFormCubit(
    this._repository,
    this._saveWallet,
    this._deleteWallet, {
    int? walletId,
    bool isDefault = false,
    LocalDate Function()? today,
  }) : _today = today ?? LocalDate.today,
       super(
         WalletFormState(
           id: walletId,
           icon: WalletIcons.keys.first,
           color: AppColors.walletPalette.first.toARGB32(),
           makeDefault: isDefault,
           wasDefault: isDefault,
         ),
       );

  final IWalletRepository _repository;
  final SaveWallet _saveWallet;
  final DeleteWallet _deleteWallet;
  final LocalDate Function() _today;
  StreamSubscription<void>? _walletsSub;

  Future<void> load() async {
    final id = state.id;
    if (id == null) {
      emit(state.copyWith(status: WalletFormStatus.ready));
      return;
    }
    // For the delete dialog; the wallets stay live while the form is open.
    _walletsSub = _repository
        .watchSummaries(DateRange.monthToDate(_today()))
        .listen(
          (result) => result.match(
            (failure) => emit(state.copyWith(status: WalletFormStatus.loadFailure, failure: failure)),
            (wallets) => emit(state.copyWith(wallets: wallets)),
          ),
        );
    final result = await _repository.getById(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(status: WalletFormStatus.loadFailure, failure: failure)),
      (wallet) => emit(
        state.copyWith(
          status: WalletFormStatus.ready,
          wallet: wallet,
          name: wallet.name ?? '',
          icon: wallet.icon,
          color: wallet.color,
        ),
      ),
    );
  }

  void nameChanged(String name) => emit(state.copyWith(name: name, nameEdited: true, nameError: null));

  void iconSelected(String icon) => emit(state.copyWith(icon: icon));

  void colorSelected(int color) => emit(state.copyWith(color: color));

  void defaultChanged({required bool value}) => emit(state.copyWith(makeDefault: value));

  Future<void> save() async {
    if (!state.canSave) return;
    emit(state.copyWith(status: WalletFormStatus.saving, nameError: null, failure: null));
    final result = await _saveWallet(
      WalletDraft(name: state.keepsSeedName ? null : state.name, icon: state.icon, color: state.color),
      id: state.id,
    );
    if (isClosed) return;
    result.match(
      (failure) => emit(switch (failure) {
        ValidationFailure(field: 'name', :final reason) => state.copyWith(
          status: WalletFormStatus.ready,
          nameError: reason,
        ),
        _ => state.copyWith(status: WalletFormStatus.ready, failure: failure),
      }),
      (id) => emit(state.copyWith(status: WalletFormStatus.saved, id: id)),
    );
  }

  /// Deletes the wallet being edited, after the user confirmed, moving its
  /// rows and templates to [moveTo].
  Future<void> delete({int? moveTo}) async {
    final id = state.id;
    if (id == null || state.status != WalletFormStatus.ready) return;
    emit(state.copyWith(status: WalletFormStatus.deleting, failure: null));
    final result = await _deleteWallet(id, moveTo: moveTo);
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(status: WalletFormStatus.ready, failure: failure)),
      (_) => emit(state.copyWith(status: WalletFormStatus.deleted)),
    );
  }

  @override
  Future<void> close() async {
    await _walletsSub?.cancel();
    return super.close();
  }
}
