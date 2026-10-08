import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';

/// The occurrence calendar of a recurring template (Recurring Expenses PRD →
/// Occurrence calculation). Pure functions, so they are unit-tested directly.
abstract final class RecurringSchedule {
  /// Occurrence [n] (0-based), always counted from [start] so month-end
  /// clamping never drifts: Jan 31 → Feb 28 → Mar 31.
  static LocalDate occurrence(LocalDate start, RecurringFrequency frequency, int n) => switch (frequency) {
    RecurringFrequency.daily => start.addDays(n),
    RecurringFrequency.weekly => start.addDays(7 * n),
    RecurringFrequency.monthly => start.addMonths(n),
    RecurringFrequency.yearly => start.addYears(n),
  };

  /// The first occurrence on or after [date] ([start] itself when [date] is
  /// earlier).
  static LocalDate firstOnOrAfter(LocalDate start, RecurringFrequency frequency, LocalDate date) {
    if (!date.isAfter(start)) return start;
    // Estimate n from the gap, then step forward: the estimate never
    // overshoots, and clamping can only make an occurrence earlier.
    var n = switch (frequency) {
      RecurringFrequency.daily => start.daysUntil(date),
      RecurringFrequency.weekly => start.daysUntil(date) ~/ 7,
      RecurringFrequency.monthly => _monthsBetween(start, date),
      RecurringFrequency.yearly => _monthsBetween(start, date) ~/ 12,
    };
    while (occurrence(start, frequency, n).isBefore(date)) {
      n++;
    }
    return occurrence(start, frequency, n);
  }

  /// The first occurrence strictly after [date].
  static LocalDate firstAfter(LocalDate start, RecurringFrequency frequency, LocalDate date) =>
      firstOnOrAfter(start, frequency, date.addDays(1));

  /// The due date after resuming a paused template: occurrences missed
  /// during the pause are skipped, so it jumps to the first one on or after
  /// [today] (never earlier than the stored [nextDue]).
  static LocalDate resumedDue(
    LocalDate start,
    RecurringFrequency frequency,
    LocalDate nextDue, {
    required LocalDate today,
  }) {
    final next = firstOnOrAfter(start, frequency, today);
    return next.isAfter(nextDue) ? next : nextDue;
  }

  /// What generation should insert for a template that is due on [nextDue]:
  /// every occurrence from [nextDue] to [today] inclusive, within the
  /// back-generation cap, and the next due date after [today].
  ///
  /// The cap keeps the last [AppConstants.maxBackGenerationDays] days, so 90
  /// days for a daily template. A weekly, monthly or yearly template always
  /// keeps its most recent missed occurrence, even when it falls outside the
  /// window, so a yearly subscription never disappears.
  static RecurringPlan plan({
    required LocalDate start,
    required RecurringFrequency frequency,
    required LocalDate nextDue,
    required LocalDate today,
  }) {
    final due = <LocalDate>[];
    for (
      var date = firstOnOrAfter(start, frequency, nextDue);
      !date.isAfter(today);
      date = firstAfter(start, frequency, date)
    ) {
      due.add(date);
    }
    final windowStart = today.addDays(1 - AppConstants.maxBackGenerationDays);
    final capped = [
      for (final date in due)
        if (!date.isBefore(windowStart)) date,
    ];
    if (capped.isEmpty && due.isNotEmpty && frequency != RecurringFrequency.daily) capped.add(due.last);
    return (occurrences: capped, nextDue: due.isEmpty ? nextDue : firstAfter(start, frequency, today));
  }

  static int _monthsBetween(LocalDate from, LocalDate to) => (to.year - from.year) * 12 + to.month - from.month - 1;
}

/// The occurrences to insert, oldest first, and the template's new due date.
typedef RecurringPlan = ({List<LocalDate> occurrences, LocalDate nextDue});
