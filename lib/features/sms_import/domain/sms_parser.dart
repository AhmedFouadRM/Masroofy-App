import 'package:masroofy/core/domain/digits.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/parsed_sms.dart';
import 'package:masroofy/features/sms_import/domain/merchant_cleaner.dart';

/// Reads a bank or wallet SMS into a [ParsedSms], with no network and no
/// state. Rule based: real templates per bank (`EGBANK`), and generic English
/// and Arabic patterns for every other sender, at low confidence.
abstract final class SmsParser {
  /// Confidence of a message that matched one of a bank's own templates.
  static const templateConfidence = 0.95;

  /// Confidence of a generic pattern on a built-in sender's message.
  static const knownSenderGenericConfidence = 0.5;

  /// Confidence of a generic pattern on a sender we don't know.
  static const unknownSenderGenericConfidence = 0.4;

  /// How far ahead of the SMS time a date in the text may be before it is
  /// taken to be last year's (clock skew).
  static const _futureTolerance = Duration(minutes: 5);

  /// Parses [body] sent by [sender] and received at [receivedAt].
  ///
  /// Returns null when the message is not a transaction: an OTP, a declined
  /// or failed one, a promotion, a balance alert, or anything with no amount
  /// and currency. A message that cancels a purchase is returned with
  /// [SmsKind.cancellation].
  static ParsedSms? parse(String sender, String body, DateTime receivedAt) {
    final text = _normalize(body);
    if (text.isEmpty) return null;

    final known = SenderCatalog.lookup(sender);
    if (known?.id == 'egbank') {
      // A full template match is a transaction whatever the merchant is called.
      final parsed = _egBank(text, receivedAt);
      if (parsed != null) return parsed;
    }
    if (_isIgnored(text)) return null;
    return _generic(
      text,
      receivedAt,
      bankName: known?.name ?? sender.trim(),
      confidence: known == null ? unknownSenderGenericConfidence : knownSenderGenericConfidence,
    );
  }

  // ── Normalising ──

  /// Western digits, `.` and `,` separators, no bidi marks, single spaces.
  static String _normalize(String body) => toWesternDigits(body)
      .replaceAll(arabicDecimalSeparator, '.')
      .replaceAll(arabicGroupSeparator, ',')
      .replaceAll(RegExp('[\u200e\u200f\u202a-\u202e\u2066-\u2069\u00a0]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  // ── Patterns ──

  static const _currencyToken = r'(?:EGP|SAR|AED|QAR|KWD|BHD|OMR|JOD|MAD|USD|EUR|GBP|جم|ج\.\s?م\.?|جنيه)';
  static const _number = r'\d{1,3}(?:,\d{3})+(?:\.\d+)?|\d+(?:\.\d+)?';

  /// `EGP 200`, `143.37جم`, `5 ج.م.`, `1,200.50 EGP`: groups 1-2 are the
  /// currency-first form, 3-4 the number-first form.
  static final _money = RegExp(
    '(?<![A-Za-z\u0600-\u06FF])($_currencyToken)(?![A-Za-z\u0600-\u06FF])\\s*($_number)(?![\\d])'
    '|($_number)\\s*($_currencyToken)(?![A-Za-z\u0600-\u06FF])',
    caseSensitive: false,
  );

  static final _otp = RegExp(
    r'\botp\b|one[\s-]?time|verification|verify|passcode|\bcode\b|رمز|كلمة\s+(?:السر|المرور)|كود|التحقق|التفعيل',
    caseSensitive: false,
  );

  static final _declined = RegExp(
    r'declin|reject|unsuccessful|\bfailed\b|not\s+(?:approved|successful|completed)|insufficient|denied'
    r'|مرفوض|رفض|فشل|لم\s+تتم|لم\s+يتم|غير\s+ناجح|غير\s+كاف|تعذر',
    caseSensitive: false,
  );

  static final _promo = RegExp(
    r'\boffers?\b|promo|discount|%\s*off|congratulat|apply\s+now|\bclick\b|https?://|www\.|bit\.ly|\bloan\b'
    r'|limited\s+time|عرض|عروض|خصم\s*\d+\s*%|\d+\s*%\s*خصم|مبروك|اشترك|سجل\s+الآن|قرض|تقسيط|احصل\s+على',
    caseSensitive: false,
  );

  static final _cancellation = RegExp(
    r'[اإ]لغاء|[اأ]لغ[يى]|\bcancell?ed\b|\bcancellation\b|\breversal\b|\breversed\b|\bvoided\b',
    caseSensitive: false,
  );

  static final _income = RegExp(
    r'credited|deposited|\bdeposit\b|salary|refund|received'
    '|[إا]يداع|راتب|مرتب|استرداد|مسترد|استلام|وارد|[إا]ضافة',
    caseSensitive: false,
  );

  static final _expense = RegExp(
    r'purchase|spent|debited|withdrawal|withdrawn|withdraw|\bpaid\b|payment|charged|\bsent\b|transfer(?:red)?\s+to'
    r'|شراء|الشراء|سحب|خصم|مدين|دفع|الدفع|تحويل\s+[اإ]لى|مصروف|صرف',
    caseSensitive: false,
  );

  static final _balanceContext = RegExp(
    r'(?:balance|bal\.?|avl|available|الرصيد|رصيدك|رصيد)[^\d]{0,25}$',
    caseSensitive: false,
  );

  static bool _isIgnored(String text) => _otp.hasMatch(text) || _declined.hasMatch(text) || _promo.hasMatch(text);

  // ── EG Bank ──

  static const _bankName = 'EG Bank';

  /// `Your account was credited by EGP 200 on 07-10 14:33 IPN REF# 123 from NAME`
  static final _egInstaPay = RegExp(
    _fill(
      r'^Your account was (credited|charged) by (<CUR>)\s*(<NUM>) on '
      r'(\d{1,2})-(\d{1,2})(?:\s+(\d{1,2}):(\d{2}))?\s+IPN\s+REF#?\s*(\d+)(?:\s+(?:from|to)\s+(.+?))?(?:\s+for details.*)?$',
    ),
    caseSensitive: false,
  );

  /// `تم الشراء بمبلغ 5جم على الكارت رقم  +++9033 من Uber`; `تم الغاء الشراء` cancels it.
  static final _egPurchase = RegExp(
    _fill(
      r'^تم\s+([اإ]لغاء\s+)?الشراء\s+بمبلغ\s*(<NUM>)\s*(<CUR>)\s+على\s+الكارت\s+رقم\s*[+*xX•]*(\d{4})\s+من\s+(.+?)'
      r'(?:\s+(?:for details|للتفاصيل).*)?$',
    ),
  );

  /// Puts the currency and number patterns where a template says `<CUR>` and `<NUM>`.
  static String _fill(String template) => template.replaceAll('<CUR>', _currencyToken).replaceAll('<NUM>', _number);

  static ParsedSms? _egBank(String text, DateTime receivedAt) {
    final ipn = _egInstaPay.firstMatch(text);
    if (ipn != null) {
      final currency = _currencyCode(ipn.group(2)!);
      final amount = _money2(ipn.group(3)!, currency);
      if (amount == null) return null;
      final hour = ipn.group(6);
      return ParsedSms(
        kind: ipn.group(1)!.toLowerCase() == 'credited' ? SmsKind.income : SmsKind.expense,
        amount: amount,
        currency: currency,
        occurredAt:
            _inferDate(
              receivedAt,
              day: int.parse(ipn.group(4)!),
              month: int.parse(ipn.group(5)!),
              hour: hour == null ? null : int.parse(hour),
              minute: hour == null ? null : int.parse(ipn.group(7)!),
            ) ??
            receivedAt,
        confidence: templateConfidence,
        merchant: MerchantCleaner.tidy(ipn.group(9)),
        reference: ipn.group(8),
        bankName: _bankName,
        channel: 'InstaPay',
      );
    }

    final purchase = _egPurchase.firstMatch(text);
    if (purchase != null) {
      final currency = _currencyCode(purchase.group(3)!);
      final amount = _money2(purchase.group(2)!, currency);
      if (amount == null) return null;
      return ParsedSms(
        kind: purchase.group(1) == null ? SmsKind.expense : SmsKind.cancellation,
        amount: amount,
        currency: currency,
        occurredAt: receivedAt,
        confidence: templateConfidence,
        merchant: MerchantCleaner.clean(purchase.group(5)),
        cardLast4: purchase.group(4),
        bankName: _bankName,
      );
    }
    return null;
  }

  // ── Generic ──

  static ParsedSms? _generic(
    String text,
    DateTime receivedAt, {
    required String bankName,
    required double confidence,
  }) {
    final kind = _kindOf(text);
    if (kind == null) return null;

    // The first amount that is not a balance is the transaction's.
    ({Money amount, String currency})? main;
    ({Money amount, String currency})? balance;
    for (final match in _money.allMatches(text)) {
      final currency = _currencyCode(match.group(1) ?? match.group(4)!);
      final amount = _money2(match.group(2) ?? match.group(3)!, currency, allowZero: true);
      if (amount == null) continue;
      final before = text.substring(0, match.start);
      if (_balanceContext.hasMatch(before)) {
        balance ??= (amount: amount, currency: currency);
      } else if (main == null && amount.isPositive) {
        main = (amount: amount, currency: currency);
      }
    }
    if (main == null) return null;

    final merchant = switch (kind) {
      SmsKind.income => _merchantAfter(text, income: true),
      _ => _merchantAfter(text, income: false),
    };
    return ParsedSms(
      kind: kind,
      amount: main.amount,
      currency: main.currency,
      occurredAt: _genericDate(text, receivedAt) ?? receivedAt,
      confidence: confidence,
      merchant: kind == SmsKind.income ? MerchantCleaner.tidy(merchant) : MerchantCleaner.clean(merchant),
      cardLast4: _last4(text),
      balance: balance != null && balance.currency == main.currency ? balance.amount : null,
      reference: RegExp(
        r'ref(?:erence)?\.?\s*(?:no\.?|#|:)?\s*([A-Za-z0-9]{6,})',
        caseSensitive: false,
      ).firstMatch(text)?.group(1),
      bankName: bankName,
    );
  }

  static SmsKind? _kindOf(String text) {
    if (_cancellation.hasMatch(text)) return SmsKind.cancellation;
    if (_income.hasMatch(text)) return SmsKind.income;
    if (_expense.hasMatch(text)) return SmsKind.expense;
    return null;
  }

  /// Where a merchant's name ends: the next field of the message.
  static const _stopEnglish =
      r'\s+(?:on|using|with|via|card|ending|ref|avail|available|balance|bal|date|was|is|has|were|for details)\b';
  static const _stopArabic = r'\s+(?:في|بتاريخ|على|رصيد|الرصيد|بطاقة|الكارت|للتفاصيل)(?![\u0600-\u06FF])';

  /// The merchant (or, for income, the sender): what follows `at` / `to`
  /// (spending) or `from` (income), or its Arabic counterpart, up to the next
  /// field. Earlier words win, so "debited from your account at Uber" is Uber.
  static String? _merchantAfter(String text, {required bool income}) {
    final english = income ? const ['from'] : const ['at', 'to'];
    final arabic = income ? const ['من'] : const ['لدى|عند', '[اإ]لى', 'من'];
    const stop = '$_stopEnglish|$_stopArabic|[.;؛]|\$';
    for (final word in english) {
      final match = RegExp(
        '(?:^|\\s)(?:$word)\\s+([A-Za-z0-9][^.;]*?)(?=$stop)',
        caseSensitive: false,
      ).firstMatch(text);
      if (match != null) return match.group(1);
    }
    // Not "from your account": the account words are never the merchant.
    const notAccount = '(?!(?:حساب|بطاق|كارت|الكارت|رصيد))';
    for (final word in arabic) {
      final match = RegExp('(?:^|\\s)(?:$word)\\s+$notAccount([^\\s.;؛][^.;؛]*?)(?=$stop)').firstMatch(text);
      if (match != null) return match.group(1);
    }
    return null;
  }

  static String? _last4(String text) {
    final match = RegExp(
      r'(?:card|acct|account|a/c|ending(?:\s+in)?|الكارت|بطاقة|حساب|رقم)[^\d]{0,12}(\d{4})(?!\d)'
      r'|[*+•]{2,}(\d{4})(?!\d)|[xX]{2,}(\d{4})(?!\d)',
      caseSensitive: false,
    ).firstMatch(text);
    return match?.group(1) ?? match?.group(2) ?? match?.group(3);
  }

  /// `on 07-10 14:33`, `date: 07/10/2026`, `بتاريخ 07-10`.
  static DateTime? _genericDate(String text, DateTime receivedAt) {
    final match = RegExp(
      r'(?:\bon|\bdate|\bat|في|بتاريخ)\s*:?\s*(\d{1,2})[-/](\d{1,2})(?:[-/](\d{2,4}))?(?:\s+(\d{1,2}):(\d{2}))?',
      caseSensitive: false,
    ).firstMatch(text);
    if (match == null) return null;
    final year = match.group(3);
    final hour = match.group(4);
    return _inferDate(
      receivedAt,
      day: int.parse(match.group(1)!),
      month: int.parse(match.group(2)!),
      year: year == null ? null : (year.length == 2 ? 2000 + int.parse(year) : int.parse(year)),
      hour: hour == null ? null : int.parse(hour),
      minute: hour == null ? null : int.parse(match.group(5)!),
    );
  }

  // ── Values ──

  /// A day and month with no year take the SMS's year, or the year before
  /// when that would put the date in the future. A date with a year must not
  /// be in the future. Null when it is not a real date, or is in the future.
  static DateTime? _inferDate(
    DateTime receivedAt, {
    required int day,
    required int month,
    int? year,
    int? hour,
    int? minute,
  }) {
    DateTime? build(int y) {
      final value = DateTime(y, month, day, hour ?? 0, minute ?? 0);
      final real = value.month == month && value.day == day && (hour ?? 0) < 24 && (minute ?? 0) < 60;
      return real ? value : null;
    }

    final limit = receivedAt.add(_futureTolerance);
    if (year != null) {
      final explicit = build(year);
      return explicit == null || explicit.isAfter(limit) ? null : explicit;
    }
    final thisYear = build(receivedAt.year);
    if (thisYear == null) return null;
    return thisYear.isAfter(limit) ? build(receivedAt.year - 1) : thisYear;
  }

  static String _currencyCode(String token) {
    final upper = token.toUpperCase();
    if (CurrencyUtils.byCode(upper) != null) return upper;
    return 'EGP'; // جم, ج.م, جنيه
  }

  static Money? _money2(String number, String currency, {bool allowZero = false}) {
    final digits = CurrencyUtils.byCode(currency)?.fractionDigits ?? 2;
    final clean = number.replaceAll(',', '');
    final parts = clean.split('.');
    final fraction = parts.length > 1 ? parts[1] : '';
    final padded = fraction.length >= digits ? fraction.substring(0, digits) : fraction.padRight(digits, '0');
    final minor = int.tryParse('${parts[0]}$padded');
    if (minor == null || (minor == 0 && !allowZero)) return null;
    return Money(minor);
  }
}
