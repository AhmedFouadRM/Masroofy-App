import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';

part 'recurring_list_state.freezed.dart';

enum RecurringListStatus { loading, loaded, failure }

@freezed
abstract class RecurringListState with _$RecurringListState {
  const factory RecurringListState({
    @Default(RecurringListStatus.loading) RecurringListStatus status,

    /// Active first, each group by next due date.
    @Default(<RecurringExpense>[]) List<RecurringExpense> templates,

    /// Every category (hidden ones too), by id.
    @Default(<int, Category>{}) Map<int, Category> categories,
    Failure? loadFailure,

    /// A pause, resume or delete that failed; the row was restored.
    Failure? actionFailure,
  }) = _RecurringListState;

  const RecurringListState._();

  List<RecurringExpense> get active => [
    for (final t in templates)
      if (t.isActive) t,
  ];

  List<RecurringExpense> get paused => [
    for (final t in templates)
      if (!t.isActive) t,
  ];
}
