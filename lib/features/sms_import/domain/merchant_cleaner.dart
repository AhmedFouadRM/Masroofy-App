/// Cleans the merchant text of a bank message into a name worth showing.
abstract final class MerchantCleaner {
  /// Payment processors and terminal types that prefix the merchant.
  static final _prefix = RegExp(
    r'^(?:GEIDEA|PAYMOB|PAYSKY|FAWRY|POS|ECOM)(?![A-Za-z0-9])[\s*\-_.:/]*',
    caseSensitive: false,
  );

  /// City words after which the rest is a terminal or branch code.
  static const _cities = {
    'cairo',
    'giza',
    'alex',
    'alexandria',
    'downtown',
    'maadi',
    'zamalek',
    'dokki',
    'heliopolis',
    'mohandessin',
    'riyadh',
    'jeddah',
    'dubai',
    'doha',
    'القاهرة',
    'الجيزة',
    'الاسكندرية',
    'الإسكندرية',
  };

  static const maxLength = 100;

  /// Whitespace collapsed, nothing else changed: for a person's name.
  static String? tidy(String? raw) {
    final collapsed = raw?.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (collapsed == null || collapsed.isEmpty) return null;
    return _clip(collapsed);
  }

  /// The merchant of a purchase: processor prefixes stripped, whitespace
  /// collapsed, and a trailing city or terminal suffix dropped. Keeps the
  /// original case. Null when nothing is left.
  static String? clean(String? raw) {
    final collapsed = tidy(raw);
    if (collapsed == null) return null;
    var text = collapsed;
    var stripped = text.replaceFirst(_prefix, '');
    while (stripped != text) {
      text = stripped;
      stripped = text.replaceFirst(_prefix, '');
    }
    if (text.isEmpty) return collapsed;

    final words = text.split(' ');
    // The first word is never a suffix: "Cairo Kitchen" is a merchant.
    for (var i = 1; i < words.length; i++) {
      final word = words[i].replaceAll(RegExp(r'^[^\w\u0600-\u06FF]+|[^\w\u0600-\u06FF]+$'), '').toLowerCase();
      if (_cities.contains(word)) {
        text = words.sublist(0, i).join(' ');
        break;
      }
    }
    text = text.replaceAll(RegExp(r'[\s*\-_.,:/]+$'), '').trim();
    return text.isEmpty ? collapsed : _clip(text);
  }

  static String _clip(String text) => text.length <= maxLength ? text : text.substring(0, maxLength).trimRight();
}
