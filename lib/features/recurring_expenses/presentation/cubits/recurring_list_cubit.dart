import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/delete_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/set_recurring_active.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_list_state.dart';

export 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_list_state.dart';

/// The Recurring Expenses list: live templates, pause/resume and delete.
class RecurringListCubit extends Cubit<RecurringListState> {
  RecurringListCubit(this._repository, this._categories, this._setActive, this._delete)
    : super(const RecurringListState());

  final IRecurringExpenseRepository _repository;
  final ICategoryRepository _categories;
  final SetRecurringActive _setActive;
  final DeleteRecurring _delete;
  final _subscriptions = <StreamSubscription<void>>[];

  void load() {
    _subscriptions
      ..add(
        _repository.watchAll().listen(
          (result) => result.match(
            (failure) => emit(state.copyWith(status: RecurringListStatus.failure, loadFailure: failure)),
            (templates) => emit(state.copyWith(status: RecurringListStatus.loaded, templates: templates)),
          ),
        ),
      )
      ..add(
        // Hidden categories too: an old template may still use one.
        _categories
            .watchAll(includeHidden: true)
            .listen(
              (result) => result.match(
                (failure) => emit(state.copyWith(status: RecurringListStatus.failure, loadFailure: failure)),
                (categories) => emit(state.copyWith(categories: {for (final c in categories) c.id: c})),
              ),
            ),
      );
  }

  /// Pauses or resumes at once; the switch reverts if saving fails.
  Future<void> setActive(int id, {required bool active}) => _optimistic(
    [
      for (final t in state.templates)
        if (t.id == id) t.copyWith(isActive: active) else t,
    ],
    () => _setActive(id, active: active),
  );

  /// Deletes after the user confirmed. The row goes at once (so a swipe can
  /// finish) and comes back if the delete fails.
  Future<void> delete(int id) => _optimistic(
    [
      for (final t in state.templates)
        if (t.id != id) t,
    ],
    () => _delete(id),
  );

  Future<void> _optimistic(List<RecurringExpense> templates, Future<Either<Failure, Unit>> Function() run) async {
    final previous = state.templates;
    // Reset so the same failure twice still reaches the listener.
    emit(state.copyWith(templates: templates, actionFailure: null));
    final result = await run();
    if (isClosed) return;
    result.match((failure) => emit(state.copyWith(templates: previous, actionFailure: failure)), (_) {});
  }

  @override
  Future<void> close() async {
    await Future.wait(_subscriptions.map((s) => s.cancel()));
    return super.close();
  }
}
