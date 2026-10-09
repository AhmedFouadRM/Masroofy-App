import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallets_state.dart';

export 'package:masroofy/features/wallets/presentation/cubits/wallets_state.dart';

/// Settings → Wallets: a live list of wallets with this month's balance.
class WalletsCubit extends Cubit<WalletsState> {
  WalletsCubit(this._repository, {LocalDate Function()? today})
    : _today = today ?? LocalDate.today,
      super(const WalletsState());

  final IWalletRepository _repository;
  final LocalDate Function() _today;
  StreamSubscription<void>? _subscription;

  /// Starts watching; the list updates after any add, edit, delete or new
  /// transaction.
  void load() {
    unawaited(_subscription?.cancel());
    _subscription = _repository
        .watchSummaries(DateRange.monthToDate(_today()))
        .listen(
          (result) => result.match(
            (failure) => emit(state.copyWith(status: WalletsStatus.failure, loadFailure: failure)),
            (wallets) => emit(state.copyWith(status: WalletsStatus.loaded, wallets: wallets, loadFailure: null)),
          ),
        );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
