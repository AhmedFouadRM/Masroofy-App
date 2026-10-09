/// The normalised form of a merchant name, used to remember the category the
/// user chose and to match a cancellation to its purchase.
abstract final class MerchantKey {
  /// Lower case, letters and digits only, words separated by one space;
  /// null when nothing is left.
  static String? of(String? merchant) {
    if (merchant == null) return null;
    final key = merchant.toLowerCase().replaceAll(RegExp('[^a-z0-9\u0600-\u06FF]+'), ' ').trim();
    return key.isEmpty ? null : key;
  }
}
