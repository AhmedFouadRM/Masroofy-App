import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/utils/date_utils.dart';

void main() {
  setUpAll(initializeDateFormatting);

  group('firstWeekdayFor', () {
    int first(String language, [String? country]) =>
        DateUtilsHelper.firstWeekdayFor(languageCode: language, countryCode: country);

    test('uses the device region', () {
      expect(first('ar', 'EG'), DateTime.saturday);
      expect(first('ar', 'SA'), DateTime.sunday);
      expect(first('en', 'US'), DateTime.sunday);
      expect(first('en', 'GB'), DateTime.monday);
      expect(first('en', 'eg'), DateTime.saturday);
      expect(first('dv', 'MV'), DateTime.friday);
    });

    test('falls back on language when the region is unknown', () {
      expect(first('ar'), DateTime.saturday);
      expect(first('en'), DateTime.monday);
      expect(first('ar', ''), DateTime.saturday);
    });
  });

  group('formatDate', () {
    final date = LocalDate(2026, 8, 19);

    test('English', () {
      expect(DateUtilsHelper.formatDate(date, languageCode: 'en'), 'Aug 19, 2026');
    });

    test('Arabic digit shapes follow the preference', () {
      final eastern = DateUtilsHelper.formatDate(date, languageCode: 'ar');
      expect(eastern, allOf(contains('١٩'), contains('٢٠٢٦')));
      expect(eastern, isNot(contains(RegExp('[0-9]'))));

      final western = DateUtilsHelper.formatDate(date, languageCode: 'ar', westernDigits: true);
      expect(western, allOf(contains('19'), contains('2026')));
      expect(western, isNot(contains(RegExp('[٠-٩]'))));
    });
  });
}
