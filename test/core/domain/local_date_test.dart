import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/local_date.dart';

void main() {
  group('construction and parsing', () {
    test('rejects dates that do not exist', () {
      expect(() => LocalDate(2026, 2, 30), throwsArgumentError);
      expect(LocalDate.tryCreate(2026, 2, 30), isNull);
      expect(LocalDate.tryCreate(2028, 2, 29), isNotNull);
    });

    test('parses strict YYYY-MM-DD and round-trips', () {
      final date = LocalDate.parse('2026-10-08');
      expect(date, LocalDate(2026, 10, 8));
      expect(date.toIso(), '2026-10-08');
      expect(LocalDate(987, 1, 2).toIso(), '0987-01-02');
    });

    test('rejects malformed or impossible ISO strings', () {
      expect(() => LocalDate.parse('2026-2-8'), throwsFormatException);
      expect(() => LocalDate.parse('2026-02-30'), throwsFormatException);
      expect(() => LocalDate.parse('2026-10-08T00:00'), throwsFormatException);
    });

    test('fromDateTime keeps the calendar fields regardless of time', () {
      expect(LocalDate.fromDateTime(DateTime.utc(2026, 10, 8, 23, 30)), LocalDate(2026, 10, 8));
      expect(LocalDate.fromDateTime(DateTime(2026, 10, 8, 0, 0, 1)), LocalDate(2026, 10, 8));
    });
  });

  group('month and year arithmetic', () {
    test('monthly schedule anchored on the 31st clamps without drifting', () {
      final anchor = LocalDate(2026, 1, 31);
      expect(anchor.addMonths(1), LocalDate(2026, 2, 28));
      expect(anchor.addMonths(2), LocalDate(2026, 3, 31));
      expect(anchor.addMonths(3), LocalDate(2026, 4, 30));
      expect(anchor.addMonths(4), LocalDate(2026, 5, 31));
    });

    test('leap years', () {
      expect(LocalDate(2028, 1, 31).addMonths(1), LocalDate(2028, 2, 29));
      expect(LocalDate(2028, 2, 29).addYears(1), LocalDate(2029, 2, 28));
      expect(LocalDate(2028, 2, 29).addYears(4), LocalDate(2032, 2, 29));
      expect(LocalDate(2028, 2, 1).endOfMonth, LocalDate(2028, 2, 29));
    });

    test('crosses year boundaries in both directions', () {
      expect(LocalDate(2026, 12, 15).addMonths(1), LocalDate(2027, 1, 15));
      expect(LocalDate(2026, 3, 31).addMonths(-1), LocalDate(2026, 2, 28));
      expect(LocalDate(2026, 1, 15).addMonths(-1), LocalDate(2025, 12, 15));
      expect(LocalDate(2026, 12, 31).addDays(1), LocalDate(2027, 1, 1));
    });
  });

  group('weeks and day counts', () {
    // 2026-10-08 is a Thursday.
    final thursday = LocalDate(2026, 10, 8);

    test('weekday uses DateTime numbering', () {
      expect(thursday.weekday, DateTime.thursday);
    });

    test('startOfWeek honours the region first weekday', () {
      expect(thursday.startOfWeek(DateTime.saturday), LocalDate(2026, 10, 3));
      expect(thursday.startOfWeek(DateTime.sunday), LocalDate(2026, 10, 4));
      expect(thursday.startOfWeek(DateTime.monday), LocalDate(2026, 10, 5));
      expect(LocalDate(2026, 10, 3).startOfWeek(DateTime.saturday), LocalDate(2026, 10, 3));
    });

    test('daysUntil and ordering', () {
      expect(LocalDate(2026, 1, 1).daysUntil(LocalDate(2026, 12, 31)), 364);
      expect(thursday.isBefore(thursday.addDays(1)), isTrue);
      expect(thursday.isAfter(thursday), isFalse);
      expect({thursday, LocalDate(2026, 10, 8)}, hasLength(1));
    });
  });
}
