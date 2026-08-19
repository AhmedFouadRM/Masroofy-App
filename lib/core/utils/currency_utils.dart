import 'package:intl/intl.dart';

class CurrencyUtils {
  CurrencyUtils._();

  static const Map<String, String> supportedCurrencies = {
    'EGP': 'Egyptian Pound',
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'SAR': 'Saudi Riyal',
    'AED': 'UAE Dirham',
  };

  static String formatAmount(double amount, String currencyCode, String locale) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: getCurrencySymbol(currencyCode),
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'EGP':
        return 'Ø¬.Ù…';
      case 'USD':
        return '\$';
      case 'EUR':
        return 'â‚¬';
      case 'SAR':
        return 'Ø±.Ø³';
      case 'AED':
        return 'Ø¯.Ø¥';
      default:
        return currencyCode;
    }
  }
}
