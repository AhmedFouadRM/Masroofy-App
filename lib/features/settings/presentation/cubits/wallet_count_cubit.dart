import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';

/// How many wallets there are: the trailing value of Settings → Wallets. Null
/// until the first count arrives.
class WalletCountCubit extends Cubit<int?> {
  WalletCountCubit(this._wallets, {LocalDate Function()? today}) : _today = today ?? LocalDate.today, super(null);

  final IWalletRepository _wallets;
  final LocalDate Function() _today;
  StreamSubscription<void>? _subscription;

  void load() {
    unawaited(_subscription?.cancel());
    _subscription = _wallets
        .watchSummaries(DateRange.monthToDate(_today()))
        .listen((result) => result.match((_) {}, (wallets) => emit(wallets.length)));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
