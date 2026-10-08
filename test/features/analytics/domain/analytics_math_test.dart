import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/analytics/domain/analytics_math.dart';

void main() {
  LocalDate d(int y, int m, int day) => LocalDate(y, m, day);

  group('bucketFor', () {
    test('days up to 31, weeks up to 180, then months', () {
      final start = d(2026, 1, 1);
      expect(AnalyticsMath.bucketFor(DateRange(start, start.addDays(30))), SpendingBucket.day);
      expect(AnalyticsMath.bucketFor(DateRange(start, start.addDays(31))), SpendingBucket.week);
      expect(AnalyticsMath.bucketFor(DateRange(start, start.addDays(179))), SpendingBucket.week);
      expect(AnalyticsMath.bucketFor(DateRange(start, start.addDays(180))), SpendingBucket.month);
    });
  });

  group('bars', () {
    test('one bar per day, zero-filled', () {
      final range = DateRange(d(2026, 10, 1), d(2026, 10, 3));
      final bars = AnalyticsMath.bars(
        range,
        {d(2026, 10, 2): const Money(500)},
        bucket: SpendingBucket.day,
        firstWeekday: DateTime.saturday,
      );
      expect(bars, [
        (start: d(2026, 10, 1), total: Money.zero),
        (start: d(2026, 10, 2), total: const Money(500)),
        (start: d(2026, 10, 3), total: Money.zero),
      ]);
    });

    test('weeks start on the region week day; the first one is clipped to the range', () {
      // Oct 1 2026 is a Thursday; weeks start on Saturday.
      final range = DateRange(d(2026, 10, 1), d(2026, 10, 12));
      final bars = AnalyticsMath.bars(
        range,
        {d(2026, 10, 1): const Money(100), d(2026, 10, 3): const Money(200), d(2026, 10, 10): const Money(400)},
        bucket: SpendingBucket.week,
        firstWeekday: DateTime.saturday,
      );
      expect(bars, [
        (start: d(2026, 10, 1), total: const Money(100)),
        (start: d(2026, 10, 3), total: const Money(200)),
        (start: d(2026, 10, 10), total: const Money(400)),
      ]);
    });

    test('months sum their days', () {
      final range = DateRange(d(2026, 1, 15), d(2026, 3, 2));
      final bars = AnalyticsMath.bars(
        range,
        {d(2026, 1, 20): const Money(1), d(2026, 1, 31): const Money(2), d(2026, 3, 1): const Money(4)},
        bucket: SpendingBucket.month,
        firstWeekday: DateTime.monday,
      );
      expect(bars.map((b) => (b.start, b.total.minor)), [(d(2026, 1, 15), 3), (d(2026, 2, 1), 0), (d(2026, 3, 1), 4)]);
    });
  });

  group('slices', () {
    test('largest first; small categories grouped last', () {
      final slices = AnalyticsMath.slices({
        1: const Money(9000),
        2: const Money(800),
        3: const Money(100),
        4: const Money(100),
      });
      expect(slices.map((s) => (s.categoryId, s.total.minor, s.members.join(','))), [
        (1, 9000, '1'),
        (2, 800, '2'),
        (null, 200, '3,4'),
      ]);
    });

    test('the real Other category is never grouped', () {
      final slices = AnalyticsMath.slices(
        {1: const Money(9800), 8: const Money(100), 3: const Money(50), 4: const Money(50)},
        otherCategoryId: 8,
      );
      expect(slices.map((s) => s.categoryId), [1, 8, null]);
    });

    test('a single small category keeps its own slice', () {
      final slices = AnalyticsMath.slices({1: const Money(9900), 2: const Money(100)});
      expect(slices.map((s) => s.categoryId), [1, 2]);
    });

    test('no spending, no slices', () {
      expect(AnalyticsMath.slices({}), isEmpty);
    });
  });

  test('niceInterval picks 1, 2 or 5 times a power of ten', () {
    expect(AnalyticsMath.niceInterval(0), 1);
    expect(AnalyticsMath.niceInterval(100), 50);
    expect(AnalyticsMath.niceInterval(380), 100);
    expect(AnalyticsMath.niceInterval(123456), 50000);
  });

  test('Last Month compares with the whole month before it', () {
    final september = DateRange.fullMonth(d(2026, 9, 10));
    expect(september, DateRange(d(2026, 9, 1), d(2026, 9, 30)));
    expect(ComparisonPeriod.forFullMonth(september), DateRange(d(2026, 8, 1), d(2026, 8, 31)));
  });
}
