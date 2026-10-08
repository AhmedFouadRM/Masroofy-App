import 'package:meta/meta.dart';

/// A calendar date with no time and no timezone.
///
/// Used for expense dates, recurring due dates, and budget/analytics windows.
/// Storing a `DateTime` instead would let a timezone or DST change move an
/// expense to a neighbouring day. Persisted as `YYYY-MM-DD`.
@immutable
final class LocalDate implements Comparable<LocalDate> {
  /// Creates a date; throws [ArgumentError] if it doesn't exist (e.g. Feb 30).
  factory LocalDate(int year, int month, int day) =>
      tryCreate(year, month, day) ?? (throw ArgumentError('Invalid date: $year-$month-$day'));

  const LocalDate._(this.year, this.month, this.day);

  /// Takes the calendar fields of [dateTime] as they are (local or UTC).
  factory LocalDate.fromDateTime(DateTime dateTime) =>
      LocalDate._(dateTime.year, dateTime.month, dateTime.day);

  /// The device-local calendar date.
  factory LocalDate.today() => LocalDate.fromDateTime(DateTime.now());

  /// Parses strict `YYYY-MM-DD`; throws [FormatException] otherwise.
  factory LocalDate.parse(String iso) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(iso);
    if (match == null) throw FormatException('Expected YYYY-MM-DD', iso);
    return tryCreate(
          int.parse(match.group(1)!),
          int.parse(match.group(2)!),
          int.parse(match.group(3)!),
        ) ??
        (throw FormatException('Invalid calendar date', iso));
  }

  factory LocalDate._fromUtc(DateTime utc) => LocalDate._(utc.year, utc.month, utc.day);

  /// Returns `null` instead of throwing when the date doesn't exist.
  static LocalDate? tryCreate(int year, int month, int day) {
    final utc = DateTime.utc(year, month, day);
    if (utc.year != year || utc.month != month || utc.day != day) return null;
    return LocalDate._(year, month, day);
  }

  final int year;
  final int month;
  final int day;

  static const int _msPerDay = Duration.millisecondsPerDay;

  DateTime get _utc => DateTime.utc(year, month, day);

  /// Days since 1970-01-01.
  int get epochDay => _utc.millisecondsSinceEpoch ~/ _msPerDay;

  /// 1 = Monday … 7 = Sunday (same as [DateTime.weekday]).
  int get weekday => _utc.weekday;

  int get daysInMonth => DateTime.utc(year, month + 1, 0).day;

  LocalDate get startOfMonth => LocalDate._(year, month, 1);
  LocalDate get endOfMonth => LocalDate._(year, month, daysInMonth);

  LocalDate addDays(int days) => LocalDate._fromUtc(_utc.add(Duration(days: days)));

  /// Adds calendar months, clamping the day to the target month's last day.
  ///
  /// For a recurring schedule, always add `n` months to the **anchor** date
  /// rather than chaining: Jan 31 +1 → Feb 28, Jan 31 +2 → Mar 31.
  LocalDate addMonths(int months) {
    final totalMonths = year * 12 + (month - 1) + months;
    final targetYear = totalMonths ~/ 12;
    final targetMonth = totalMonths % 12 + 1;
    final lastDay = DateTime.utc(targetYear, targetMonth + 1, 0).day;
    return LocalDate._(targetYear, targetMonth, day > lastDay ? lastDay : day);
  }

  /// Adds calendar years; Feb 29 clamps to Feb 28 in non-leap years.
  LocalDate addYears(int years) => addMonths(years * 12);

  /// Signed number of days from this date to [other].
  int daysUntil(LocalDate other) => other.epochDay - epochDay;

  /// The first day of the week containing this date.
  /// [firstWeekday] uses [DateTime.weekday] numbering (6 = Saturday, 7 = Sunday, 1 = Monday).
  LocalDate startOfWeek(int firstWeekday) {
    final offset = (weekday - firstWeekday) % 7;
    return addDays(-offset);
  }

  bool isBefore(LocalDate other) => compareTo(other) < 0;
  bool isAfter(LocalDate other) => compareTo(other) > 0;

  /// Local midnight of this date, for APIs (e.g. `DateFormat`) that need a `DateTime`.
  DateTime toDateTime() => DateTime(year, month, day);

  String toIso() =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  @override
  int compareTo(LocalDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  @override
  bool operator ==(Object other) =>
      other is LocalDate && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso();
}
