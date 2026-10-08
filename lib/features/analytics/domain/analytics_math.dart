import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';

/// How much time one bar covers (Analytics PRD → Bar Chart).
enum SpendingBucket { day, week, month }

/// One bar: the bucket's first day (clamped to the range) and its total.
typedef SpendingBar = ({LocalDate start, Money total});

/// One pie slice. `categoryId` is null for the grouped "Smaller categories".
typedef SpendingSlice = ({int? categoryId, Money total, List<int> members});

/// Pure chart maths, unit-tested directly.
abstract final class AnalyticsMath {
  /// Slices under this share of the total are grouped (PRD: < 3%).
  static const smallSliceShare = 0.03;

  /// ≤ 31 days → days, 32–180 → weeks, longer → months.
  static SpendingBucket bucketFor(DateRange range) => switch (range.lengthInDays) {
    <= 31 => SpendingBucket.day,
    <= 180 => SpendingBucket.week,
    _ => SpendingBucket.month,
  };

  /// Every bucket in [range], oldest first, with zero-spend ones included so
  /// the time axis has no gaps. Weeks start on [firstWeekday]; the first and
  /// last bucket may be partial.
  static List<SpendingBar> bars(
    DateRange range,
    Map<LocalDate, Money> daily, {
    required SpendingBucket bucket,
    required int firstWeekday,
  }) {
    LocalDate startOf(LocalDate date) {
      final start = switch (bucket) {
        SpendingBucket.day => date,
        SpendingBucket.week => date.startOfWeek(firstWeekday),
        SpendingBucket.month => date.startOfMonth,
      };
      return start.isBefore(range.start) ? range.start : start;
    }

    final totals = <LocalDate, Money>{};
    for (var date = range.start; !date.isAfter(range.end); date = date.addDays(1)) {
      final key = startOf(date);
      totals[key] = (totals[key] ?? Money.zero) + (daily[date] ?? Money.zero);
    }
    return [for (final MapEntry(:key, :value) in totals.entries) (start: key, total: value)];
  }

  /// Pie slices, largest first. Categories under [smallSliceShare] of the
  /// total are grouped into one slice at the end, except [otherCategoryId]
  /// (the real Other category), which always keeps its own slice. A single
  /// small category is not worth grouping and keeps its slice.
  static List<SpendingSlice> slices(Map<int, Money> byCategory, {int? otherCategoryId}) {
    final total = Money.sum(byCategory.values);
    if (total.minor <= 0) return const [];
    final sorted = byCategory.entries.where((e) => e.value.isPositive).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    bool small(MapEntry<int, Money> e) => e.key != otherCategoryId && e.value.minor / total.minor < smallSliceShare;

    final grouped = sorted.where(small).toList();
    if (grouped.length < 2) {
      return [
        for (final e in sorted) (categoryId: e.key, total: e.value, members: [e.key]),
      ];
    }
    return [
      for (final e in sorted)
        if (!small(e)) (categoryId: e.key, total: e.value, members: [e.key]),
      (categoryId: null, total: Money.sum(grouped.map((e) => e.value)), members: [for (final e in grouped) e.key]),
    ];
  }

  /// A round axis step giving about [lines] gridlines up to [max] (1, 2 or 5
  /// times a power of ten).
  static double niceInterval(double max, {int lines = 4}) {
    if (max <= 0) return 1;
    final raw = max / lines;
    var magnitude = 1.0;
    while (magnitude * 10 <= raw) {
      magnitude *= 10;
    }
    while (magnitude > raw) {
      magnitude /= 10;
    }
    for (final step in [1, 2, 5, 10]) {
      if (magnitude * step >= raw) return magnitude * step;
    }
    return magnitude * 10;
  }
}
