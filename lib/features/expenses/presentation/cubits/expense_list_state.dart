import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/expenses/domain/entities/list_entry.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';

part 'expense_list_state.freezed.dart';

enum ExpensePeriod { week, month, custom }

enum ExpenseListStatus { loading, loaded, failure }

@freezed
abstract class ExpenseListState with _$ExpenseListState {
  const factory ExpenseListState({
    required ExpensePeriod period,
    required DateRange range,
    @Default(ExpenseListStatus.loading) ExpenseListStatus status,

    /// The wallet being viewed; null is All wallets.
    int? walletId,

    /// The All / Income / Expenses filter; null is All.
    TransactionKind? kind,
    int? categoryId,
    @Default('') String search,

    /// The loaded page, including rows waiting out their undo window.
    @Default(<ListEntry>[]) List<ListEntry> loaded,
    @Default(false) bool hasMore,
    @Default(PeriodTotals.zero) PeriodTotals totals,

    /// Totals of the comparison period; null until loaded, and not loaded at
    /// all on All (the balance card has no comparison).
    PeriodTotals? previousTotals,
    @Default(<LocalDate, PeriodTotals>{}) Map<LocalDate, PeriodTotals> dailyTotals,

    /// All categories by id (incl. hidden, which old expenses may use).
    @Default(<int, Category>{}) Map<int, Category> categories,

    /// Every wallet with its balance this month, for the title, the switcher
    /// and the wallet names on rows.
    @Default(<WalletSummary>[]) List<WalletSummary> wallets,

    /// Swiped away, still restorable with Undo (by the id of the row listed).
    @Default(<int>{}) Set<int> pendingDelete,
    Failure? loadFailure,

    /// A failed delete, shown once as a snackbar.
    Failure? actionFailure,
  }) = _ExpenseListState;

  const ExpenseListState._();

  List<ListEntry> get entries => [
    for (final e in loaded)
      if (!pendingDelete.contains(e.id)) e,
  ];

  /// The wallet being viewed; null for All wallets.
  WalletSummary? get wallet => wallets.where((w) => w.wallet.id == walletId).firstOrNull;

  /// [totals] without the rows waiting to be deleted. In All wallets a
  /// transfer's two legs cancel out, so hiding one changes nothing.
  PeriodTotals _without(PeriodTotals totals, Iterable<ListEntry> pending) {
    var income = Money.zero;
    var spent = Money.zero;
    var transfers = Money.zero;
    for (final entry in pending) {
      switch (entry) {
        case TransactionEntry(:final expense):
          if (expense.kind == TransactionKind.income) {
            income += expense.amount;
          } else {
            spent += expense.amount;
          }
        case TransferEntry(:final transfer, walletId: final legWallet) when walletId != null:
          transfers += legWallet == transfer.toWalletId ? transfer.amount : -transfer.amount;
        case TransferEntry():
          break;
      }
    }
    return PeriodTotals.withTransfersNet(
      income: totals.income - income,
      spent: totals.spent - spent,
      transfersNet: totals.transfersNet - transfers,
    );
  }

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
