/// A built-in merchant rule: a merchant whose normalised name contains one of
/// the [keywords] belongs to the category with [seedKey].
class MerchantRule {
  const MerchantRule(this.seedKey, this.keywords);

  final String seedKey;

  /// Lower case. A keyword of Latin letters matches whole words (`we` does
  /// not match `weekend`); one with Arabic letters matches anywhere.
  final List<String> keywords;
}

/// Keyword to category seed key, for merchants the user has not categorised.
/// Checked in order, so more specific rules come first.
abstract final class MerchantCatalog {
  static const expenseRules = <MerchantRule>[
    MerchantRule('transport', [
      'uber',
      'careem',
      'indrive',
      'swvl',
      'didi',
      'bolt',
      'egyptair',
      'اوبر',
      'كريم',
      'مصر للطيران',
    ]),
    MerchantRule('bills', [
      'vodafone',
      'we',
      'etisalat',
      'orange',
      'telecom egypt',
      'internet',
      'electricity',
      'fawry',
      'اتصالات',
      'فودافون',
      'اورنج',
      'المصرية للاتصالات',
      'كهرباء',
      'غاز',
      'مياه',
      'فوري',
    ]),
    MerchantRule('food', [
      'carrefour',
      'spinneys',
      'hyperone',
      'hyper one',
      'seoudi',
      'kazyon',
      'fathalla',
      'gourmet',
      'metro market',
      'alfa market',
      'talabat',
      'elmenus',
      'instashop',
      'breadfast',
      'mcdonalds',
      'mcdonald',
      'kfc',
      'starbucks',
      'costa',
      'cilantro',
      'hardees',
      'pizza',
      'burger',
      'cafe',
      'coffee',
      'restaurant',
      'bakery',
      'supermarket',
      'market',
      'كارفور',
      'سبينس',
      'طلبات',
      'مطعم',
      'كافيه',
      'بيتزا',
    ]),
    MerchantRule('shopping', [
      'amazon',
      'noon',
      'jumia',
      'aliexpress',
      'shein',
      'zara',
      'ikea',
      'btech',
      '2b',
      'raya',
      'sprinter',
      'decathlon',
      'mall',
      'نون',
      'امازون',
    ]),
    MerchantRule('health', [
      'pharmacy',
      'ezaby',
      'seif',
      'vezeeta',
      'hospital',
      'clinic',
      'صيدلية',
      'مستشفى',
      'عيادة',
      'معمل',
    ]),
    MerchantRule('entertainment', [
      'netflix',
      'spotify',
      'shahid',
      'anghami',
      'osn',
      'youtube',
      'playstation',
      'steam',
      'vox',
      'cinema',
      'سينما',
    ]),
    MerchantRule('education', ['school', 'university', 'udemy', 'coursera', 'academy', 'مدرسة', 'جامعة']),
  ];

  static const incomeRules = <MerchantRule>[
    MerchantRule('salary', ['salary', 'payroll', 'راتب', 'مرتب']),
    MerchantRule('refunds', ['refund', 'reversal', 'استرداد']),
  ];
}
