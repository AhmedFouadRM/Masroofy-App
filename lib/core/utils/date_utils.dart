import 'package:intl/intl.dart';
import 'package:masroofy/core/domain/digits.dart';
import 'package:masroofy/core/domain/local_date.dart';

class DateUtilsHelper {
  DateUtilsHelper._();

  /// `Aug 19, 2026` / `١٩ أغسطس ٢٠٢٦` (or Western digits when [westernDigits]).
  /// Requires `initializeDateFormatting()` to have run (done in `main`).
  static String formatDate(
    LocalDate date, {
    required String languageCode,
    bool westernDigits = false,
  }) =>
      _shape(DateFormat.yMMMd(languageCode).format(date.toDateTime()), languageCode, westernDigits);

  /// `Aug 19` / `١٩ أغسطس`, for list group headers older than yesterday.
  static String formatShortDate(
    LocalDate date, {
    required String languageCode,
    bool westernDigits = false,
  }) =>
      _shape(DateFormat.MMMd(languageCode).format(date.toDateTime()), languageCode, westernDigits);

  static String _shape(String formatted, String languageCode, bool westernDigits) {
    if (languageCode != 'ar') return formatted;
    final western = toWesternDigits(formatted);
    return westernDigits ? western : toEasternArabicNumber(western);
  }

  /// First day of the week for a device region, as a [DateTime.weekday] value
  /// (1 = Monday, 6 = Saturday, 7 = Sunday).
  ///
  /// From CLDR `weekData/firstDay`. `intl` only ships week data for a handful
  /// of region locales (no `ar_SA`, `ar_AE`, `ar_KW`…), so the table is kept
  /// here. Without a region, Arabic falls back to Saturday (the primary
  /// market, Egypt) and everything else to Monday (CLDR world default).
  static int firstWeekdayFor({required String languageCode, String? countryCode}) {
    final region = countryCode?.toUpperCase();
    if (region != null && region.isNotEmpty) {
      if (_saturdayRegions.contains(region)) return DateTime.saturday;
      if (_sundayRegions.contains(region)) return DateTime.sunday;
      if (region == 'MV') return DateTime.friday;
      return DateTime.monday;
    }
    return languageCode == 'ar' ? DateTime.saturday : DateTime.monday;
  }

  static const _saturdayRegions = {
    'AF', 'BH', 'DJ', 'DZ', 'EG', 'IQ', 'IR', 'JO', 'KW', 'LY', 'OM', 'QA', 'SD', 'SY',
  };

  static const _sundayRegions = {
    'AG', 'AS', 'BD', 'BR', 'BS', 'BT', 'BW', 'BZ', 'CA', 'CN', 'CO', 'DM', 'DO', 'ET',
    'GT', 'GU', 'HK', 'HN', 'ID', 'IL', 'IN', 'JM', 'JP', 'KE', 'KH', 'KR', 'LA', 'MH',
    'MM', 'MO', 'MT', 'MX', 'MZ', 'NI', 'NP', 'PA', 'PE', 'PH', 'PK', 'PR', 'PT', 'PY',
    'SA', 'SG', 'SV', 'TH', 'TT', 'TW', 'UM', 'US', 'VE', 'VI', 'WS', 'YE', 'ZA', 'ZW',
  };
}
