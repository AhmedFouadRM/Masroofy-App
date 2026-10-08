import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';

void main() {
  final thursday = LocalDate(2026, 10, 8);

  test('week to date starts on the regional first weekday', () {
    expect(
      DateRange.weekToDate(thursday, firstWeekday: DateTime.saturday),
      DateRange(LocalDate(2026, 10, 3), thursday),
    );
    expect(DateRange.weekToDate(thursday, firstWeekday: DateTime.monday), DateRange(LocalDate(2026, 10, 5), thursday));
  });

  test('length and contains are inclusive', () {
    final range = DateRange.monthToDate(thursday);
    expect(range.lengthInDays, 8);
    expect(range.contains(LocalDate(2026, 10, 1)), isTrue);
    expect(range.contains(thursday), isTrue);
    expect(range.contains(LocalDate(2026, 9, 30)), isFalse);
  });

  test('rejects an end before the start', () {
    expect(() => DateRange(thursday, LocalDate(2026, 10, 7)), throwsArgumentError);
  });

  group('comparison period', () {
    test('week to date → the same days of last week', () {
      final range = DateRange.weekToDate(thursday, firstWeekday: DateTime.saturday);
      expect(ComparisonPeriod.forWeekToDate(range), DateRange(LocalDate(2026, 9, 26), LocalDate(2026, 10, 1)));
    });

    test('month to date → days 1…k of last month, clamped', () {
      expect(
        ComparisonPeriod.forMonthToDate(DateRange.monthToDate(thursday)),
        DateRange(LocalDate(2026, 9, 1), LocalDate(2026, 9, 8)),
      );
      expect(
        ComparisonPeriod.forMonthToDate(DateRange.monthToDate(LocalDate(2026, 3, 31))),
        DateRange(LocalDate(2026, 2, 1), LocalDate(2026, 2, 28)),
      );
    });

    test('custom → the same number of days right before', () {
      final range = DateRange(LocalDate(2026, 10, 1), LocalDate(2026, 10, 10));
      expect(ComparisonPeriod.forCustom(range), DateRange(LocalDate(2026, 9, 21), LocalDate(2026, 9, 30)));
    });
  });
}
