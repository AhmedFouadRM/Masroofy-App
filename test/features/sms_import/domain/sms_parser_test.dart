import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/sms_import/domain/entities/parsed_sms.dart';
import 'package:masroofy/features/sms_import/domain/sms_parser.dart';

import 'egbank_samples.dart';

void main() {
  /// The SMS time of the samples: Oct 9, 2026, mid-afternoon.
  final received = DateTime(2026, 10, 9, 15, 20, 30);

  ParsedSms? parse(String body, {String sender = 'EGBANK', DateTime? at}) =>
      SmsParser.parse(sender, body, at ?? received);

  group('EG Bank templates (the PRD samples, verbatim)', () {
    test('1. credited by InstaPay is income from the sender, with the time of the text', () {
      final parsed = parse(EgBankSamples.instaPayCredit)!;

      expect(parsed.kind, SmsKind.income);
      expect(parsed.amount, const Money(20000));
      expect(parsed.currency, 'EGP');
      expect(parsed.merchant, 'NADA MOHAMED ABDELM**');
      expect(parsed.occurredAt, DateTime(2026, 10, 7, 14, 33));
      expect(parsed.date.toIso(), '2026-10-07');
      expect(parsed.reference, '65520277090');
      expect(parsed.cardLast4, isNull);
      expect(parsed.channel, 'InstaPay');
      expect(parsed.bankName, 'EG Bank');
      expect(parsed.note, 'InstaPay · Ref 65520277090');
      expect(parsed.isConfident, isTrue);
    });

    test('2. a purchase through GEIDEA drops the processor, the city and the terminal', () {
      final parsed = parse(EgBankSamples.purchaseGeidea)!;

      expect(parsed.kind, SmsKind.expense);
      expect(parsed.amount, const Money(14337));
      expect(parsed.currency, 'EGP');
      expect(parsed.merchant, 'ALBAN ZAHER 6');
      expect(parsed.cardLast4, '9033');
      // No date in the text: the SMS time.
      expect(parsed.occurredAt, received);
      expect(parsed.note, 'EG Bank ••9033');
      expect(parsed.isConfident, isTrue);
    });

    test('3. charged by InstaPay is an expense with no merchant', () {
      final parsed = parse(EgBankSamples.instaPayDebit)!;

      expect(parsed.kind, SmsKind.expense);
      expect(parsed.amount, const Money(26000));
      expect(parsed.currency, 'EGP');
      expect(parsed.merchant, isNull);
      expect(parsed.occurredAt, DateTime(2026, 10, 5, 17, 53));
      expect(parsed.reference, '13192168771');
      expect(parsed.note, 'InstaPay · Ref 13192168771');
      expect(parsed.isConfident, isTrue);
    });

    test('4. a purchase at Uber keeps the merchant and drops the branch', () {
      final parsed = parse(EgBankSamples.purchaseUber)!;

      expect(parsed.kind, SmsKind.expense);
      expect(parsed.amount, const Money(500));
      expect(parsed.currency, 'EGP');
      expect(parsed.merchant, 'Uber');
      expect(parsed.cardLast4, '9033');
      expect(parsed.occurredAt, received);
      expect(parsed.note, 'EG Bank ••9033');
      expect(parsed.isConfident, isTrue);
    });

    test('5. the cancellation names the same card, amount and merchant as sample 4', () {
      final cancel = parse(EgBankSamples.cancelUber)!;
      final purchase = parse(EgBankSamples.purchaseUber)!;

      expect(cancel.kind, SmsKind.cancellation);
      expect(cancel.kind.transactionKind.name, 'expense');
      expect(cancel.amount, purchase.amount);
      expect(cancel.cardLast4, purchase.cardLast4);
      expect(cancel.merchant, purchase.merchant);
      expect(cancel.merchantKey, purchase.merchantKey);
      expect(cancel.isConfident, isTrue);
    });

    test('the sender ID matches however it is written', () {
      for (final sender in ['EGBANK', 'egbank', 'EG-BANK', ' EGBANK ']) {
        expect(parse(EgBankSamples.purchaseUber, sender: sender)!.confidence, SmsParser.templateConfidence);
      }
    });
  });

  group('dates', () {
    test('take the year of the SMS', () {
      final parsed = parse(EgBankSamples.instaPayCredit, at: DateTime(2026, 10, 9, 8))!;
      expect(parsed.occurredAt, DateTime(2026, 10, 7, 14, 33));
    });

    test('use the previous year when this year would be in the future', () {
      // "30-12 23:10" received on Jan 2: it was December of last year.
      const body =
          'Your account was credited by EGP 200 on 30-12 23:10 IPN REF# 111 from SARA for details please call 19342';
      expect(parse(body, at: DateTime(2026, 1, 2, 9))!.occurredAt, DateTime(2025, 12, 30, 23, 10));
    });

    test('a date on the day of the SMS is not the future, a few minutes of clock skew included', () {
      const body = 'Your account was charged by EGP 50 on 09-10 15:22 IPN REF# 222 for details please call 19342';
      expect(parse(body)!.occurredAt, DateTime(2026, 10, 9, 15, 22));
      expect(parse(body, at: DateTime(2026, 10, 9, 15, 20))!.occurredAt, DateTime(2026, 10, 9, 15, 22));
    });

    test('a date later that day beyond the skew is last year', () {
      const body = 'Your account was charged by EGP 50 on 09-10 18:00 IPN REF# 222 for details please call 19342';
      expect(parse(body)!.occurredAt, DateTime(2025, 10, 9, 18));
    });

    test('an impossible date falls back to the SMS time', () {
      const body = 'Your account was charged by EGP 50 on 31-02 10:00 IPN REF# 333 for details please call 19342';
      expect(parse(body)!.occurredAt, received);
    });

    test('Feb 29 is last year only when that was a leap year', () {
      const body = 'Your account was charged by EGP 50 on 29-02 10:00 IPN REF# 333 for details please call 19342';
      // 2026 has no Feb 29: the SMS time.
      expect(parse(body, at: DateTime(2026, 3))!.occurredAt, DateTime(2026, 3));
      expect(parse(body, at: DateTime(2028, 3))!.occurredAt, DateTime(2028, 2, 29, 10));
    });
  });

  group('amounts and currencies', () {
    String purchase(String amount) =>
        'تم الشراء بمبلغ $amount على الكارت رقم  +++9033 من Uber                  Downtown';

    test('every currency token, with or without a space', () {
      for (final amount in ['5جم', '5 جم', '5ج.م', '5 ج.م.', '5جنيه', '5 جنيه']) {
        final parsed = parse(purchase(amount));
        expect(parsed, isNotNull, reason: amount);
        expect(parsed!.amount, const Money(500), reason: amount);
        expect(parsed.currency, 'EGP', reason: amount);
      }
    });

    test('EGP before the number, with or without a space', () {
      for (final amount in ['EGP 200', 'EGP200', 'egp 200']) {
        final body = 'Your account was credited by $amount on 07-10 14:33 IPN REF# 1 from SARA';
        expect(parse(body)!.amount, const Money(20000), reason: amount);
      }
    });

    test('Eastern Arabic digits', () {
      final parsed = parse('تم الشراء بمبلغ ١٤٣جم على الكارت رقم  +++٩٠٣٣ من Uber')!;
      expect(parsed.amount, const Money(14300));
      expect(parsed.cardLast4, '9033');
    });

    test('. and ٫ as the decimal separator, with thousands separators', () {
      expect(parse(purchase('143.37جم'))!.amount, const Money(14337));
      expect(parse(purchase('١٤٣٫٣٧جم'))!.amount, const Money(14337));
      expect(parse(purchase('1,234.5جم'))!.amount, const Money(123450));
      expect(parse(purchase('١٬٢٣٤٫٥٠ جم'))!.amount, const Money(123450));
      expect(parse(purchase('12,000 جم'))!.amount, const Money(1200000));
    });

    test('extra decimals are cut, not rounded up', () {
      expect(parse(purchase('5.999جم'))!.amount, const Money(599));
    });

    test('a zero amount is not a transaction', () {
      expect(parse(purchase('0جم')), isNull);
    });

    test('the currency of a message is kept: USD is not EGP', () {
      final parsed = parse('Purchase of USD 25.50 at Amazon on card ending 4321', sender: 'CIB')!;
      expect(parsed.currency, 'USD');
      expect(parsed.amount, const Money(2550));
    });

    test('a three-digit currency keeps three decimals', () {
      final parsed = parse('Purchase of KWD 12.345 at Sultan Center', sender: 'CIB')!;
      expect(parsed.currency, 'KWD');
      expect(parsed.amount, const Money(12345));
    });
  });

  group('ignored messages', () {
    test('OTPs, in English and Arabic', () {
      expect(parse('Your OTP is 123456. Do not share it with anyone.', sender: 'CIB'), isNull);
      expect(parse('Use code 5521 to verify your purchase of EGP 500 at Amazon', sender: 'CIB'), isNull);
      expect(parse('رمز التحقق الخاص بك هو 123456 لعملية شراء بمبلغ 500 جم', sender: 'CIB'), isNull);
      expect(parse('كلمة المرور لمرة واحدة 998877'), isNull);
    });

    test('declined and failed transactions', () {
      expect(parse('Your purchase of EGP 500 at Amazon was declined due to insufficient funds', sender: 'CIB'), isNull);
      expect(parse('Transaction failed: payment of EGP 99 at Netflix', sender: 'NBE'), isNull);
      expect(parse('تم رفض عملية الشراء بمبلغ 500 جم لعدم كفاية الرصيد'), isNull);
    });

    test('promotions', () {
      expect(parse('Get 20% off your next purchase! Apply now at https://cib.example/offer', sender: 'CIB'), isNull);
      expect(parse('Exclusive offer: pay EGP 99 and win a prize, limited time', sender: 'NBE'), isNull);
      expect(parse('مبروك! عرض خاص: احصل على قرض بقيمة 50000 جم', sender: 'CIB'), isNull);
    });

    test('balance-only alerts', () {
      expect(parse('Your available balance is EGP 5,000.00', sender: 'CIB'), isNull);
      expect(parse('رصيدك الحالي 5,000 جم', sender: 'NBE'), isNull);
    });

    test('empty and personal text', () {
      expect(parse(''), isNull);
      expect(parse('   '), isNull);
      expect(parse('Are you coming to dinner tonight?', sender: '+201001234567'), isNull);
    });

    test('a template match is a transaction whatever the merchant is called', () {
      // "Win" would look like a promotion in a generic pattern.
      const body = 'تم الشراء بمبلغ 50جم على الكارت رقم  +++9033 من WIN GYM Downtown';
      expect(parse(body)!.merchant, 'WIN GYM');
    });
  });

  group('generic patterns for the other banks', () {
    test('an English purchase is read, at low confidence', () {
      final parsed = parse(
        'Your CIB card ending 1234 was used for a purchase of EGP 450.00 at Carrefour on 09/10/2026. '
        'Available balance EGP 8,320.00',
        sender: 'CIB',
      )!;

      expect(parsed.kind, SmsKind.expense);
      expect(parsed.amount, const Money(45000));
      expect(parsed.currency, 'EGP');
      expect(parsed.merchant, 'Carrefour');
      expect(parsed.cardLast4, '1234');
      expect(parsed.balance, const Money(832000));
      expect(parsed.occurredAt, DateTime(2026, 10, 9));
      expect(parsed.bankName, 'CIB');
      expect(parsed.confidence, SmsParser.knownSenderGenericConfidence);
      expect(parsed.isConfident, isFalse);
      expect(parsed.note, 'CIB ••1234 · Balance EGP 8,320');
    });

    test('an English credit is income from the sender', () {
      final parsed = parse(
        'EGP 12,000.00 was credited to your account from ACME LLC. Ref 99887766. Balance EGP 20,000.00',
        sender: 'NBE',
      )!;

      expect(parsed.kind, SmsKind.income);
      expect(parsed.amount, const Money(1200000));
      expect(parsed.merchant, 'ACME LLC');
      expect(parsed.reference, '99887766');
      expect(parsed.balance, const Money(2000000));
      expect(parsed.isConfident, isFalse);
    });

    test('an Arabic debit names the merchant after لدى, not the account', () {
      final parsed = parse('تم خصم 150 جم من حسابك رقم 5678 لدى كارفور', sender: 'QNB')!;

      expect(parsed.kind, SmsKind.expense);
      expect(parsed.amount, const Money(15000));
      expect(parsed.merchant, 'كارفور');
      expect(parsed.cardLast4, '5678');
      expect(parsed.isConfident, isFalse);
    });

    test('an Arabic deposit is income', () {
      final parsed = parse('تم إيداع مبلغ ١٢٠٠٠ جم في حسابك', sender: 'BANQUEMISR')!;
      expect(parsed.kind, SmsKind.income);
      expect(parsed.amount, const Money(1200000));
    });

    test('a cancellation is recognised', () {
      final parsed = parse('Your purchase of EGP 85.00 at Uber was cancelled', sender: 'CIB')!;
      expect(parsed.kind, SmsKind.cancellation);
      expect(parsed.amount, const Money(8500));
      expect(parsed.merchant, 'Uber');
    });

    test('a message from EG Bank in no known template is generic, not confident', () {
      final parsed = parse('Purchase of EGP 75.00 at Netflix, card ending 9033')!;
      expect(parsed.merchant, 'Netflix');
      expect(parsed.isConfident, isFalse);
    });

    test('a message with an amount but no debit or credit word is not a transaction', () {
      expect(parse('Your monthly statement of EGP 500 is ready', sender: 'CIB'), isNull);
    });

    test('a message with a word but no amount is not a transaction', () {
      expect(parse('Your purchase was successful', sender: 'CIB'), isNull);
    });

    test('a generic pattern never reaches the high confidence an automatic import needs', () {
      expect(SmsParser.knownSenderGenericConfidence, lessThan(ParsedSms.highConfidence));
      expect(SmsParser.unknownSenderGenericConfidence, lessThan(ParsedSms.highConfidence));
    });
  });

  group('unknown senders', () {
    test('a bank-like message from a stranger is parsed at an even lower confidence', () {
      final parsed = parse('Your account was debited with EGP 300 at Zara', sender: 'BANQUEMIS')!;
      expect(parsed.amount, const Money(30000));
      expect(parsed.bankName, 'BANQUEMIS');
      expect(parsed.confidence, SmsParser.unknownSenderGenericConfidence);
    });

    test('the EG Bank template is only for EG Bank', () {
      final parsed = parse(EgBankSamples.purchaseUber, sender: 'SOMEBANK')!;
      expect(parsed.isConfident, isFalse);
    });
  });

  group('the note', () {
    test('has the bank and the last 4 digits', () {
      final parsed = ParsedSms(
        kind: SmsKind.expense,
        amount: const Money(100),
        currency: 'EGP',
        occurredAt: received,
        confidence: 1,
        bankName: 'CIB',
        cardLast4: '1234',
      );
      expect(parsed.note, 'CIB ••1234');
      expect(parsed.copyWith(balance: const Money(832000)).note, 'CIB ••1234 · Balance EGP 8,320');
      expect(parsed.copyWith(cardLast4: null).note, 'CIB');
      expect(parsed.copyWith(bankName: null, cardLast4: null).note, '');
    });

    test('shows the balance with decimals when it has them', () {
      final parsed = ParsedSms(
        kind: SmsKind.expense,
        amount: const Money(100),
        currency: 'EGP',
        occurredAt: received,
        confidence: 1,
        bankName: 'CIB',
        balance: const Money(832050),
      );
      expect(parsed.note, 'CIB · Balance EGP 8,320.50');
    });
  });
}
