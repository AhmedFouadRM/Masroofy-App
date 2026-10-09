import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';
import 'package:masroofy/features/budgets/domain/usecases/delete_budget.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_list_state.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';

export 'package:masroofy/features/budgets/presentation/cubits/budget_list_state.dart';

/// Manage Budgets: every budget with its current-period progress.
class BudgetListCubit extends Cubit<BudgetListState> {
  BudgetListCubit(
    this._budgets,
    this._categories,
    this._deleteBudget, {
    required this.firstWeekday,
    LocalDate Function()? today,
  }) : _today = today ?? LocalDate.today,
       super(const BudgetListState());

  final IBudgetRepository _budgets;
  final ICategoryRepository _categories;
  final DeleteBudget _deleteBudget;
  final LocalDate Function() _today;

  /// `DateTime.weekday` the week starts on, from the device region.
  final int firstWeekday;
  final _subscriptions = <StreamSubscription<void>>[];

  void load() {
    _subscriptions
      ..add(
        _budgets
            .watchProgress(_today(), firstWeekday: firstWeekday)
            .listen(
              (result) => result.match(
                (failure) => emit(state.copyWith(status: BudgetListStatus.failure, loadFailure: failure)),
                (budgets) => emit(state.copyWith(status: BudgetListStatus.loaded, budgets: budgets)),
              ),
            ),
      )
      ..add(
        _categories
            .watchAll(includeHidden: true)
            .listen(
              (result) => result.match(
                (failure) => emit(state.copyWith(status: BudgetListStatus.failure, loadFailure: failure)),
                (categories) => emit(state.copyWith(categories: {for (final c in categories) c.id: c})),
              ),
            ),
      );
  }

  /// Deletes after the user confirmed. The row goes at once (so a swipe can
  /// finish) and comes back if the delete fails.
  Future<void> delete(int id) async {
    final previous = state.budgets;
    emit(
      state.copyWith(
        budgets: [
          for (final b in previous)
            if (b.budget.id != id) b,
        ],
        // Reset so the same failure twice still reaches the listener.
        actionFailure: null,
      ),
    );
    final result = await _deleteBudget(id);
    if (isClosed) return;
    result.match((failure) => emit(state.copyWith(budgets: previous, actionFailure: failure)), (_) {});
  }

  @override
  Future<void> close() async {
    await Future.wait(_subscriptions.map((s) => s.cancel()));
    return super.close();
  }
}
