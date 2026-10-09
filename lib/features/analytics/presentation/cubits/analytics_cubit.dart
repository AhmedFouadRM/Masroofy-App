import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/analytics/domain/repositories/i_analytics_repository.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_state.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';

export 'package:masroofy/features/analytics/presentation/cubits/analytics_state.dart';

/// The Analytics dashboard: live totals for the selected period, for one
/// wallet or All wallets. Budgets stay global.
class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(
    this._analytics,
    this._categories,
    this._budgets,
    this._wallets, {
    required int firstWeekday,
    int? walletId,
    LocalDate Function()? today,
  }) : _today = today ?? LocalDate.today,
       super(
         AnalyticsState(
           period: AnalyticsPeriod.month,
           range: DateRange.monthToDate((today ?? LocalDate.today)()),
           firstWeekday: firstWeekday,
           walletId: walletId,
         ),
       );

  final IAnalyticsRepository _analytics;
  final ICategoryRepository _categories;
  final IBudgetRepository _budgets;
  final IWalletRepository _wallets;
  StreamSubscription<void>? _budgetsSub;
  StreamSubscription<void>? _walletsSub;
  final LocalDate Function() _today;
  StreamSubscription<void>? _categoriesSub;
  final List<StreamSubscription<void>> _rangeSubs = [];
  StreamSubscription<void>? _breakdownSub;

  void load() {
    unawaited(_categoriesSub?.cancel());
    _categoriesSub = _categories
        .watchAll(includeHidden: true)
        .listen(
          (result) => result.match(
            _onFailure,
            (categories) => emit(state.copyWith(categories: {for (final c in categories) c.id: c})),
          ),
        );
    unawaited(_walletsSub?.cancel());
    _walletsSub = _wallets
        .watchSummaries(state.range)
        .listen(
          (r) => r.match(
            _onFailure,
            (wallets) => emit(state.copyWith(wallets: [for (final w in wallets) w.wallet], walletSummaries: wallets)),
          ),
        );
    // Budgets always show their own current period, whatever the range.
    unawaited(_budgetsSub?.cancel());
    _budgetsSub = _budgets
        .watchProgress(_today(), firstWeekday: state.firstWeekday)
        .listen((r) => r.match(_onFailure, (budgets) => emit(state.copyWith(budgets: budgets))));
    _subscribe();
  }

  /// This week / this month (to date) or the whole of last month.
  void selectPeriod(AnalyticsPeriod period) {
    final today = _today();
    final range = switch (period) {
      AnalyticsPeriod.week => DateRange.weekToDate(today, firstWeekday: state.firstWeekday),
      AnalyticsPeriod.month => DateRange.monthToDate(today),
      AnalyticsPeriod.lastMonth => DateRange.fullMonth(today.startOfMonth.addDays(-1)),
      AnalyticsPeriod.custom => state.range,
    };
    _select(period, range);
  }

  void selectCustomRange(DateRange range) => _select(AnalyticsPeriod.custom, range);

  /// Shows one wallet, or All wallets (null).
  void selectWallet(int? walletId) {
    if (walletId == state.walletId) return;
    emit(state.copyWith(walletId: walletId, previousTotal: null));
    _subscribe();
  }

  /// Switches the breakdown card between spending and income by category.
  void selectBreakdown(TransactionKind kind) {
    if (kind == state.breakdownKind) return;
    emit(state.copyWith(breakdownKind: kind, byCategory: const {}));
    _subscribeBreakdown();
  }

  void _select(AnalyticsPeriod period, DateRange range) {
    if (period == state.period && range == state.range) return;
    emit(state.copyWith(period: period, range: range, previousTotal: null));
    _subscribe();
  }

  DateRange get _comparisonRange => switch (state.period) {
    AnalyticsPeriod.week => ComparisonPeriod.forWeekToDate(state.range),
    AnalyticsPeriod.month => ComparisonPeriod.forMonthToDate(state.range),
    AnalyticsPeriod.lastMonth => ComparisonPeriod.forFullMonth(state.range),
    AnalyticsPeriod.custom => ComparisonPeriod.forCustom(state.range),
  };

  void _subscribe() {
    for (final sub in _rangeSubs) {
      unawaited(sub.cancel());
    }
    final range = state.range;
    final walletId = state.walletId;
    _rangeSubs
      ..clear()
      ..add(
        _analytics
            .watchTotals(range, walletId: walletId)
            .listen(
              (r) => r.match(
                _onFailure,
                (totals) => emit(state.copyWith(status: AnalyticsStatus.loaded, totals: totals)),
              ),
            ),
      )
      ..add(
        _analytics
            .watchTotals(_comparisonRange, walletId: walletId)
            .listen((r) => r.match(_onFailure, (totals) => emit(state.copyWith(previousTotal: totals.spent)))),
      )
      ..add(
        _analytics
            .watchDailyTotals(range, walletId: walletId)
            .listen((r) => r.match(_onFailure, (totals) => emit(state.copyWith(daily: totals)))),
      );
    // The By wallet card compares wallets, so it only exists in All wallets.
    if (walletId == null) {
      _rangeSubs.add(
        _analytics
            .watchTotalsByWallet(range)
            .listen((r) => r.match(_onFailure, (totals) => emit(state.copyWith(byWallet: totals)))),
      );
    } else if (state.byWallet.isNotEmpty) {
      emit(state.copyWith(byWallet: const {}));
    }
    _subscribeBreakdown();
  }

  void _subscribeBreakdown() {
    unawaited(_breakdownSub?.cancel());
    _breakdownSub = _analytics
        .watchTotalsByCategory(state.range, state.breakdownKind, walletId: state.walletId)
        .listen((r) => r.match(_onFailure, (totals) => emit(state.copyWith(byCategory: totals))));
  }

  void _onFailure(Failure failure) => emit(state.copyWith(status: AnalyticsStatus.failure, failure: failure));

  @override
  Future<void> close() async {
    await _categoriesSub?.cancel();
    await _budgetsSub?.cancel();
    await _walletsSub?.cancel();
    await _breakdownSub?.cancel();
    await Future.wait(_rangeSubs.map((s) => s.cancel()));
    return super.close();
  }
}
