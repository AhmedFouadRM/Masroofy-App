import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
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

    /// The All / Income / Expenses filter; null is All.
    TransactionKind? kind,
    int? categoryId,
    @Default('') String search,

    /// The loaded page, including rows waiting out their undo window.
    @Default(<Expense>[]) List<Expense> loaded,
    @Default(false) bool hasMore,
    @Default(PeriodTotals.zero) PeriodTotals totals,

    /// Totals of the comparison period; null until loaded, and not loaded at
    /// all on All (the balance card has no comparison).
    PeriodTotals? previousTotals,
    @Default(<LocalDate, PeriodTotals>{}) Map<LocalDate, PeriodTotals> dailyTotals,

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

  /// [totals] without the rows waiting to be deleted.
  static PeriodTotals _without(PeriodTotals totals, Iterable<Expense> pending) => PeriodTotals(
    income:
        totals.income -
        Money.sum([
          for (final e in pending)
            if (e.kind == TransactionKind.income) e.amount,
        ]),
    spent:
        totals.spent -
        Money.sum([
          for (final e in pending)
            if (e.kind == TransactionKind.expense) e.amount,
        ]),
  );

  /// The period totals without the rows waiting to be deleted.
  PeriodTotals get visibleTotals => _without(totals, loaded.where((e) => pendingDelete.contains(e.id)));

  /// One day's totals, likewise without the rows waiting to be deleted.
  PeriodTotals dayTotals(LocalDate day) => _without(
    dailyTotals[day] ?? PeriodTotals.zero,
    loaded.where((e) => e.date == day && pendingDelete.contains(e.id)),
  );

  /// Categories offered as filter chips: those of the selected [kind] (all
  /// of them on All); hidden ones are left out.
  List<Category> get filterCategories => [
    for (final c in categories.values)
      if (!c.isHidden && (kind == null || c.kind == kind)) c,
  ];

  bool get isFiltered => categoryId != null || search.trim().isNotEmpty;
}
