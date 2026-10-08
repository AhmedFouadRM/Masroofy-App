import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';

part 'expense_list_state.freezed.dart';

enum ExpensePeriod { week, month, custom }

enum ExpenseListStatus { loading, loaded, failure }

@freezed
abstract class ExpenseListState with _$ExpenseListState {
  const factory ExpenseListState({
    required ExpensePeriod period,
    required DateRange range,
    @Default(ExpenseListStatus.loading) ExpenseListStatus status,
    int? categoryId,
    @Default('') String search,

    /// The loaded page, including rows waiting out their undo window.
    @Default(<Expense>[]) List<Expense> loaded,
    @Default(false) bool hasMore,
    @Default(Money.zero) Money total,

    /// Total of the comparison period; null until it has loaded.
    Money? previousTotal,
    @Default(<LocalDate, Money>{}) Map<LocalDate, Money> dailyTotals,

    /// All categories by id (incl. hidden, which old expenses may use).
    @Default(<int, Category>{}) Map<int, Category> categories,

    /// Swiped away, still restorable with Undo.
    @Default(<int>{}) Set<int> pendingDelete,
    Failure? loadFailure,

    /// A failed delete, shown once as a snackbar.
    Failure? actionFailure,
  }) = _ExpenseListState;

  const ExpenseListState._();

  List<Expense> get expenses => [
    for (final e in loaded)
      if (!pendingDelete.contains(e.id)) e,
  ];

  Money get _pendingTotal => Money.sum([
    for (final e in loaded)
      if (pendingDelete.contains(e.id)) e.amount,
  ]);

  /// The period total without the rows waiting to be deleted.
  Money get visibleTotal => total - _pendingTotal;

  Money dayTotal(LocalDate day) =>
      (dailyTotals[day] ?? Money.zero) -
      Money.sum([
        for (final e in loaded)
          if (e.date == day && pendingDelete.contains(e.id)) e.amount,
      ]);

  /// Categories offered as filter chips (hidden ones are left out).
  List<Category> get filterCategories => [
    for (final c in categories.values)
      if (!c.isHidden) c,
  ];

  bool get isFiltered => categoryId != null || search.trim().isNotEmpty;
}
