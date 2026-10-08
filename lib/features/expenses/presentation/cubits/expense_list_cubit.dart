import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/expenses/domain/usecases/delete_expense.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_state.dart';

export 'package:masroofy/features/expenses/presentation/cubits/expense_list_state.dart';

/// The home screen: a live, filterable, paged list with period totals.
class ExpenseListCubit extends Cubit<ExpenseListState> {
  ExpenseListCubit(
    this._expenses,
    this._categories,
    this._deleteExpense, {
    required this.firstWeekday,
    LocalDate Function()? today,
  }) : _today = today ?? LocalDate.today,
       super(
         ExpenseListState(period: ExpensePeriod.month, range: DateRange.monthToDate((today ?? LocalDate.today)())),
       );

  static const pageSize = 50;
  static const searchDebounce = Duration(milliseconds: 300);

  final IExpenseRepository _expenses;
  final ICategoryRepository _categories;
  final DeleteExpense _deleteExpense;
  final LocalDate Function() _today;

  /// `DateTime.weekday` the week starts on, from the device region.
  final int firstWeekday;

  int _limit = pageSize;
  Timer? _searchTimer;
  StreamSubscription<void>? _categoriesSub;
  final List<StreamSubscription<void>> _filterSubs = [];
  StreamSubscription<void>? _pageSub;

  /// Ids whose delete was sent (successfully or in flight).
  final Set<int> _committed = {};

  ExpenseFilter get _filter => ExpenseFilter(range: state.range, categoryId: state.categoryId, search: state.search);

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
    _subscribe();
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
    emit(next.copyWith(status: ExpenseListStatus.loading, previousTotal: null));
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
      _expenses.watchTotal(filter).listen((r) => r.match(_onLoadFailure, (t) => emit(state.copyWith(total: t)))),
      _expenses
          .watchTotal(comparison)
          .listen((r) => r.match(_onLoadFailure, (t) => emit(state.copyWith(previousTotal: t)))),
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
        .watchExpenses(_filter, limit: limit)
        .listen(
          (result) => result.match(
            _onLoadFailure,
            (expenses) => emit(
              state.copyWith(
                status: ExpenseListStatus.loaded,
                loaded: expenses,
                hasMore: expenses.length == limit,
                // A deleted row stays hidden until the stream has dropped it.
                pendingDelete: {
                  for (final id in state.pendingDelete)
                    if (!_committed.contains(id) || expenses.any((e) => e.id == id)) id,
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

  void undoDelete(int id) => emit(state.copyWith(pendingDelete: {...state.pendingDelete}..remove(id)));

  /// Called when the undo window closes without Undo.
  Future<void> commitDelete(int id) async {
    if (!state.pendingDelete.contains(id) || !_committed.add(id)) return;
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
    await _pageSub?.cancel();
    await Future.wait([for (final sub in _filterSubs) sub.cancel()]);
    return super.close();
  }
}
