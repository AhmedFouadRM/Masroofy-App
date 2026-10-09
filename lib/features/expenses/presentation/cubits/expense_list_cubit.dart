import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/expenses/domain/usecases/delete_expense.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_state.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';

export 'package:masroofy/features/expenses/presentation/cubits/expense_list_state.dart';

/// The home screen: a live, filterable, paged list of transactions (expenses,
/// income and transfers) with period totals, for one wallet or All wallets.
class ExpenseListCubit extends Cubit<ExpenseListState> {
  ExpenseListCubit(
    this._expenses,
    this._categories,
    this._wallets,
    this._deleteExpense, {
    required this.firstWeekday,
    int? walletId,
    LocalDate Function()? today,
  }) : _today = today ?? LocalDate.today,
       super(
         ExpenseListState(
           period: ExpensePeriod.month,
           range: DateRange.monthToDate((today ?? LocalDate.today)()),
           walletId: walletId,
         ),
       );

  static const pageSize = 50;
  static const searchDebounce = Duration(milliseconds: 300);

  final IExpenseRepository _expenses;
  final ICategoryRepository _categories;
  final IWalletRepository _wallets;
  final DeleteExpense _deleteExpense;
  final LocalDate Function() _today;

  /// `DateTime.weekday` the week starts on, from the device region.
  final int firstWeekday;

  int _limit = pageSize;
  Timer? _searchTimer;
  StreamSubscription<void>? _categoriesSub;
  StreamSubscription<void>? _walletsSub;
  final List<StreamSubscription<void>> _filterSubs = [];
  StreamSubscription<void>? _pageSub;

  /// Ids whose delete was sent (successfully or in flight).
  final Set<int> _committed = {};

  ExpenseFilter get _filter => ExpenseFilter(
    range: state.range,
    walletId: state.walletId,
    kind: state.kind,
    categoryId: state.categoryId,
    search: state.search,
  );

  void load() {
    unawaited(_categoriesSub?.cancel());
    _categoriesSub = _categories
        .watchAll(includeHidden: true)
        .listen(
          (result) => result.match(
            _onLoadFailure,
            (categories) => emit(state.copyWith(categories: {for (final c in categories) c.id: c})),
          ),
        );
    // The switcher and the rows show each wallet's balance this month.
    unawaited(_walletsSub?.cancel());
    _walletsSub = _wallets
        .watchSummaries(DateRange.monthToDate(_today()))
        .listen((result) => result.match(_onLoadFailure, (wallets) => emit(state.copyWith(wallets: wallets))));
    _subscribe();
  }

  /// Views one wallet, or All wallets (null). Rows, totals, filters and
  /// search follow.
  void selectWallet(int? walletId) {
    if (walletId == state.walletId) return;
    _apply(state.copyWith(walletId: walletId));
  }

  /// This week / this month, both up to today.
  void selectPeriod(ExpensePeriod period) {
    final today = _today();
    final range = switch (period) {
      ExpensePeriod.week => DateRange.weekToDate(today, firstWeekday: firstWeekday),
      ExpensePeriod.month => DateRange.monthToDate(today),
      ExpensePeriod.custom => state.range,
    };
    _apply(state.copyWith(period: period, range: range));
  }

  void selectCustomRange(DateRange range) => _apply(state.copyWith(period: ExpensePeriod.custom, range: range));

  /// All (null), Income or Expenses. A selected category of the other kind
  /// is dropped.
  void selectKind(TransactionKind? kind) {
    final category = state.categories[state.categoryId];
    final keepCategory = kind == null || category?.kind == kind;
    _apply(state.copyWith(kind: kind, categoryId: keepCategory ? state.categoryId : null));
  }

  void selectCategory(int? categoryId) => _apply(state.copyWith(categoryId: categoryId));

  /// Debounced, so typing doesn't re-query on every key.
  void searchChanged(String text) {
    _searchTimer?.cancel();
    _searchTimer = Timer(searchDebounce, () => _apply(state.copyWith(search: text)));
  }

  void clearFilters() {
    _searchTimer?.cancel();
    _apply(state.copyWith(categoryId: null, search: ''));
  }

  /// Loads the next page when the user nears the end of the list.
  void loadMore() {
    if (!state.hasMore) return;
    _limit += pageSize;
    _subscribePage();
  }

  void _apply(ExpenseListState next) {
    if (isClosed) return;
    _limit = pageSize;
    emit(next.copyWith(status: ExpenseListStatus.loading, previousTotals: null));
    _subscribe();
  }

  void _subscribe() {
    for (final sub in _filterSubs) {
      unawaited(sub.cancel());
    }
    _filterSubs.clear();
    final filter = _filter;
    final comparison = filter.copyWith(range: _comparisonRange());
    _filterSubs.addAll([
      _expenses.watchTotals(filter).listen((r) => r.match(_onLoadFailure, (t) => emit(state.copyWith(totals: t)))),
      // The balance card on All has no comparison.
      if (filter.kind != null)
        _expenses
            .watchTotals(comparison)
            .listen((r) => r.match(_onLoadFailure, (t) => emit(state.copyWith(previousTotals: t)))),
      _expenses
          .watchDailyTotals(filter)
          .listen((r) => r.match(_onLoadFailure, (d) => emit(state.copyWith(dailyTotals: d)))),
    ]);
    _subscribePage();
  }

  void _subscribePage() {
    unawaited(_pageSub?.cancel());
    final limit = _limit;
    _pageSub = _expenses
        .watchEntries(_filter, limit: limit)
        .listen(
          (result) => result.match(
            _onLoadFailure,
            (entries) => emit(
              state.copyWith(
                status: ExpenseListStatus.loaded,
                loaded: entries,
                hasMore: entries.length == limit,
                // A deleted row stays hidden until the stream has dropped it.
                pendingDelete: {
                  for (final id in state.pendingDelete)
                    if (!_committed.contains(id) || entries.any((e) => e.id == id)) id,
                },
                loadFailure: null,
              ),
            ),
          ),
        );
  }

  DateRange _comparisonRange() => switch (state.period) {
    ExpensePeriod.week => ComparisonPeriod.forWeekToDate(state.range),
    ExpensePeriod.month => ComparisonPeriod.forMonthToDate(state.range),
    ExpensePeriod.custom => ComparisonPeriod.forCustom(state.range),
  };

  void _onLoadFailure(Failure failure) {
    if (isClosed) return;
    emit(state.copyWith(status: ExpenseListStatus.failure, loadFailure: failure));
  }

  /// Swipe: hides the row at once; [commitDelete] or [undoDelete] follows.
  void hide(int id) => emit(state.copyWith(pendingDelete: {...state.pendingDelete, id}, actionFailure: null));

  void undoDelete(int id) {
    if (!isClosed) emit(state.copyWith(pendingDelete: {...state.pendingDelete}..remove(id)));
  }

  /// Called when the undo window closes without Undo.
  Future<void> commitDelete(int id) async {
    if (isClosed || !state.pendingDelete.contains(id) || !_committed.add(id)) return;
    final result = await _deleteExpense(id);
    if (isClosed) return;
    result.match((failure) {
      _committed.remove(id);
      emit(state.copyWith(pendingDelete: {...state.pendingDelete}..remove(id), actionFailure: failure));
    }, (_) {});
  }

  @override
  Future<void> close() async {
    _searchTimer?.cancel();
    // Leaving the screen ends every undo window.
    final pending = state.pendingDelete.difference(_committed);
    await Future.wait([for (final id in pending) _deleteExpense(id)]);
    await _categoriesSub?.cancel();
    await _walletsSub?.cancel();
    await _pageSub?.cancel();
    await Future.wait([for (final sub in _filterSubs) sub.cancel()]);
    return super.close();
  }
}
