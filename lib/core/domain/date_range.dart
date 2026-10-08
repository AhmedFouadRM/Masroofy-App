import 'package:masroofy/core/domain/local_date.dart';
import 'package:meta/meta.dart';

/// An inclusive range of calendar dates.
@immutable
final class DateRange {
  DateRange(this.start, this.end) {
    if (end.isBefore(start)) throw ArgumentError('end $end is before start $start');
  }

  /// This week from its first day (by region) through [today].
  factory DateRange.weekToDate(LocalDate today, {required int firstWeekday}) =>
      DateRange(today.startOfWeek(firstWeekday), today);

  /// This month from the 1st through [today].
  factory DateRange.monthToDate(LocalDate today) => DateRange(today.startOfMonth, today);

  /// The whole calendar month containing [day].
  factory DateRange.fullMonth(LocalDate day) => DateRange(day.startOfMonth, day.endOfMonth);

  final LocalDate start;
  final LocalDate end;

  int get lengthInDays => start.daysUntil(end) + 1;

  bool contains(LocalDate date) => !date.isBefore(start) && !date.isAfter(end);

  DateRange shift(int days) => DateRange(start.addDays(days), end.addDays(days));

  @override
  bool operator ==(Object other) => other is DateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => '$start..$end';
}

/// The period a summary is compared against (Analytics PRD → Comparison
/// Period Rules): equal length, immediately before, aligned to the same point.
abstract final class ComparisonPeriod {
  /// Week to date (day k) → the first k days of last week.
  static DateRange forWeekToDate(DateRange range) => range.shift(-7);

  /// Month to date (day k) → days 1…k of last month, clamped to its length.
  static DateRange forMonthToDate(DateRange range) {
    final previousStart = range.start.addMonths(-1);
    final previousEnd = range.end.addMonths(-1);
    return DateRange(
      previousStart,
      previousEnd.isAfter(previousStart.endOfMonth) ? previousStart.endOfMonth : previousEnd,
    );
  }

  /// A whole month (e.g. Last Month) → the whole month before it.
  static DateRange forFullMonth(DateRange range) => DateRange.fullMonth(range.start.addMonths(-1));

  /// Any other range of N days → the N days right before it.
  static DateRange forCustom(DateRange range) => range.shift(-range.lengthInDays);
}
