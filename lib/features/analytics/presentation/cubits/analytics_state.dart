import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/analytics/domain/analytics_math.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';

part 'analytics_state.freezed.dart';

/// The date range selector (Analytics PRD → flow step 3).
enum AnalyticsPeriod { week, month, lastMonth, custom }

enum AnalyticsStatus { loading, loaded, failure }

@freezed
abstract class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState({
    required AnalyticsPeriod period,
    required DateRange range,

    /// `DateTime.weekday` the week starts on, for weekly bars.
    required int firstWeekday,
    @Default(AnalyticsStatus.loading) AnalyticsStatus status,

    /// The wallet shown; null is All wallets.
    int? walletId,
    @Default(PeriodTotals.zero) PeriodTotals totals,

    /// Spending of the comparison period; null until it has loaded.
    Money? previousTotal,

    /// What the breakdown card shows: spending or income by category.
    @Default(TransactionKind.expense) TransactionKind breakdownKind,

    /// Totals per category of [breakdownKind].
    @Default(<int, Money>{}) Map<int, Money> byCategory,
    @Default(<LocalDate, PeriodTotals>{}) Map<LocalDate, PeriodTotals> daily,

    /// Every category (hidden ones too), by id.
    @Default(<int, Category>{}) Map<int, Category> categories,

    /// Income, spending and transfers per wallet id, for the By wallet card
    /// (All wallets only).
    @Default(<int, PeriodTotals>{}) Map<int, PeriodTotals> byWallet,

    /// Every wallet in display order.
    @Default(<Wallet>[]) List<Wallet> wallets,

    /// The same wallets with their balance for [range], for the switcher sheet.
    @Default(<WalletSummary>[]) List<WalletSummary> walletSummaries,

    /// Every budget in its own current week or month (ignores [range]).
    @Default(<BudgetProgress>[]) List<BudgetProgress> budgets,
    Failure? failure,
  }) = _AnalyticsState;

  const AnalyticsState._();

  /// The By wallet card compares wallets, so it only exists in All wallets.
  bool get showsByWallet => walletId == null;

  /// Spending in the period (income never counts).
  Money get total => totals.spent;

  /// No activity at all: nothing came in, nothing went out and nothing was
  /// transferred. A period with only transfers is not empty.
  bool get isEmpty => totals.income == Money.zero && totals.spent == Money.zero && !totals.hasTransfers;

  /// What the breakdown card adds up to.
  Money get breakdownTotal => Money.sum(byCategory.values);

  SpendingBucket get bucket => AnalyticsMath.bucketFor(range);

  List<SpendingBar> get bars => AnalyticsMath.bars(range, daily, bucket: bucket, firstWeekday: firstWeekday);

  List<SpendingSlice> get slices => AnalyticsMath.slices(
    byCategory,
    otherCategoryId: categories.values
        .where(
          (c) => c.seedKey == (breakdownKind == TransactionKind.income ? 'other_income' : 'other'),
        )
        .firstOrNull
        ?.id,
  );

  /// Categories with transactions of [breakdownKind], largest first, for the legend.
  List<(Category, Money)> get legend => [
    for (final MapEntry(:key, :value) in byCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
      if (categories[key] case final category?) (category, value),
  ];
}
