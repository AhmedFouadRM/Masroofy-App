import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';
import 'package:masroofy/features/recurring_expenses/domain/recurring_schedule.dart';

void main() {
  LocalDate d(int y, int m, int day) => LocalDate(y, m, day);
  const daily = RecurringFrequency.daily;
  const weekly = RecurringFrequency.weekly;
  const monthly = RecurringFrequency.monthly;
  const yearly = RecurringFrequency.yearly;

  group('occurrence', () {
    test('monthly from Jan 31 clamps without drifting', () {
      final start = d(2026, 1, 31);
      expect(
        [for (var n = 0; n < 5; n++) RecurringSchedule.occurrence(start, monthly, n)],
        [
          d(2026, 1, 31),
          d(2026, 2, 28),
          d(2026, 3, 31),
          d(2026, 4, 30),
          d(2026, 5, 31),
        ],
      );
    });

    test('monthly from Jan 31 lands on Feb 29 in a leap year', () {
      expect(RecurringSchedule.occurrence(d(2028, 1, 31), monthly, 1), d(2028, 2, 29));
    });

    test('yearly from Feb 29 clamps to Feb 28, and returns in leap years', () {
      final start = d(2028, 2, 29);
      expect(RecurringSchedule.occurrence(start, yearly, 1), d(2029, 2, 28));
      expect(RecurringSchedule.occurrence(start, yearly, 4), d(2032, 2, 29));
    });

    test('daily and weekly add days', () {
      expect(RecurringSchedule.occurrence(d(2026, 12, 30), daily, 3), d(2027, 1, 2));
      expect(RecurringSchedule.occurrence(d(2026, 10, 1), weekly, 2), d(2026, 10, 15));
    });
  });

  group('firstOnOrAfter / firstAfter', () {
    test('returns the start when the date is earlier', () {
      expect(RecurringSchedule.firstOnOrAfter(d(2026, 10, 9), monthly, d(2026, 1, 1)), d(2026, 10, 9));
    });

    test('an occurrence on the date itself counts as on-or-after, not after', () {
      final start = d(2026, 1, 31);
      expect(RecurringSchedule.firstOnOrAfter(start, monthly, d(2026, 3, 31)), d(2026, 3, 31));
      expect(RecurringSchedule.firstAfter(start, monthly, d(2026, 3, 31)), d(2026, 4, 30));
    });

    test('steps over clamped months', () {
      expect(RecurringSchedule.firstOnOrAfter(d(2026, 1, 31), monthly, d(2026, 3, 1)), d(2026, 3, 31));
      expect(RecurringSchedule.firstAfter(d(2026, 1, 31), monthly, d(2026, 2, 28)), d(2026, 3, 31));
    });

    test('matches a brute-force walk for every frequency', () {
      final start = d(2024, 1, 31);
      for (final frequency in RecurringFrequency.values) {
        final all = [for (var n = 0; n < 400; n++) RecurringSchedule.occurrence(start, frequency, n)];
        for (var date = d(2024, 1, 1); date.isBefore(d(2025, 3, 1)); date = date.addDays(3)) {
          final expected = all.firstWhere((o) => !o.isBefore(date));
          expect(RecurringSchedule.firstOnOrAfter(start, frequency, date), expected, reason: '$frequency $date');
        }
      }
    });
  });

  group('plan', () {
    final today = d(2026, 10, 9);

    test('nothing is due before the next due date', () {
      final plan = RecurringSchedule.plan(
        start: d(2026, 11, 1),
        frequency: monthly,
        nextDue: d(2026, 11, 1),
        today: today,
      );
      expect(plan.occurrences, isEmpty);
      expect(plan.nextDue, d(2026, 11, 1));
    });

    test('a due date of today generates today, then moves on', () {
      final plan = RecurringSchedule.plan(start: d(2026, 9, 9), frequency: monthly, nextDue: today, today: today);
      expect(plan.occurrences, [today]);
      expect(plan.nextDue, d(2026, 11, 9));
    });

    test('back-fills every missed occurrence inside the window', () {
      final plan = RecurringSchedule.plan(
        start: d(2026, 7, 31),
        frequency: monthly,
        nextDue: d(2026, 7, 31),
        today: today,
      );
      expect(plan.occurrences, [d(2026, 7, 31), d(2026, 8, 31), d(2026, 9, 30)]);
      expect(plan.nextDue, d(2026, 10, 31));
    });

    test('a daily template unopened for 200 days generates exactly the last 90', () {
      final plan = RecurringSchedule.plan(
        start: today.addDays(-200),
        frequency: daily,
        nextDue: today.addDays(-200),
        today: today,
      );
      expect(plan.occurrences, hasLength(90));
      expect(plan.occurrences.first, today.addDays(-89));
      expect(plan.occurrences.last, today);
      expect(plan.nextDue, today.addDays(1));
    });

    test('a yearly template due 200 days ago still generates that occurrence', () {
      final due = today.addDays(-200);
      final plan = RecurringSchedule.plan(start: due, frequency: yearly, nextDue: due, today: today);
      expect(plan.occurrences, [due]);
      expect(plan.nextDue, due.addYears(1));
    });

    test('a monthly template back-fills only the last 90 days', () {
      // The window starts Jul 12, so Jul 1 and earlier are skipped.
      final plan = RecurringSchedule.plan(
        start: d(2025, 1, 1),
        frequency: monthly,
        nextDue: d(2025, 1, 1),
        today: today,
      );
      expect(plan.occurrences, [d(2026, 8, 1), d(2026, 9, 1), d(2026, 10, 1)]);
      expect(plan.nextDue, d(2026, 11, 1));
    });
  });

  group('resumedDue', () {
    final today = d(2026, 10, 9);

    test('skips occurrences missed while paused', () {
      expect(
        RecurringSchedule.resumedDue(d(2026, 1, 15), monthly, d(2026, 6, 15), today: today),
        d(2026, 10, 15),
      );
    });

    test('keeps a due date of today', () {
      expect(RecurringSchedule.resumedDue(d(2026, 1, 9), monthly, d(2026, 6, 9), today: today), today);
    });

    test('never moves a future due date earlier', () {
      expect(
        RecurringSchedule.resumedDue(d(2026, 12, 1), monthly, d(2026, 12, 1), today: today),
        d(2026, 12, 1),
      );
    });
  });
}
