import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/analytics/domain/analytics_math.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';

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
    @Default(Money.zero) Money total,

    /// Total of the comparison period; null until it has loaded.
    Money? previousTotal,
    @Default(<int, Money>{}) Map<int, Money> byCategory,
    @Default(<LocalDate, Money>{}) Map<LocalDate, Money> daily,

    /// Every category (hidden ones too), by id.
    @Default(<int, Category>{}) Map<int, Category> categories,

    /// Every budget in its own current week or month (ignores [range]).
    @Default(<BudgetProgress>[]) List<BudgetProgress> budgets,
    Failure? failure,
  }) = _AnalyticsState;

  const AnalyticsState._();

  bool get isEmpty => total == Money.zero;

  SpendingBucket get bucket => AnalyticsMath.bucketFor(range);

  List<SpendingBar> get bars => AnalyticsMath.bars(range, daily, bucket: bucket, firstWeekday: firstWeekday);

  List<SpendingSlice> get slices => AnalyticsMath.slices(
    byCategory,
    otherCategoryId: categories.values.where((c) => c.seedKey == 'other').firstOrNull?.id,
  );

  /// Categories with spending, largest first, for the legend.
  List<(Category, Money)> get legend => [
    for (final MapEntry(:key, :value) in byCategory.entries.toList()..sort((a, b) => b.value.compareTo(a.value)))
      if (categories[key] case final category?) (category, value),
  ];
}
