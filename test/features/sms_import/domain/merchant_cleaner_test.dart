import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/features/sms_import/domain/merchant_cleaner.dart';
import 'package:masroofy/features/sms_import/domain/merchant_key.dart';

void main() {
  group('MerchantCleaner.clean', () {
    test('strips processor prefixes', () {
      expect(MerchantCleaner.clean('GEIDEA ALBAN ZAHER 6'), 'ALBAN ZAHER 6');
      expect(MerchantCleaner.clean('PAYMOB Talabat'), 'Talabat');
      expect(MerchantCleaner.clean('PAYSKY Noon'), 'Noon');
      expect(MerchantCleaner.clean('FAWRY Vodafone'), 'Vodafone');
      expect(MerchantCleaner.clean('POS Spinneys'), 'Spinneys');
      expect(MerchantCleaner.clean('ECOM Amazon'), 'Amazon');
    });

    test('strips stacked and separated prefixes, in any case', () {
      expect(MerchantCleaner.clean('POS GEIDEA ALBAN'), 'ALBAN');
      expect(MerchantCleaner.clean('paymob*Talabat'), 'Talabat');
      expect(MerchantCleaner.clean('ECOM-AMAZON'), 'AMAZON');
      expect(MerchantCleaner.clean('POS: Carrefour'), 'Carrefour');
    });

    test('a prefix is a whole word', () {
      expect(MerchantCleaner.clean('POSEIDON Pizza'), 'POSEIDON Pizza');
      expect(MerchantCleaner.clean('Fawryo Store'), 'Fawryo Store');
    });

    test('collapses whitespace', () {
      expect(MerchantCleaner.clean('  Uber    Trip \t Cairo'), 'Uber Trip');
      expect(MerchantCleaner.clean('Uber                  Downtown'), 'Uber');
    });

    test('drops a trailing city and everything after it', () {
      expect(MerchantCleaner.clean('ALBAN ZAHER 6 CAIRO S 07E'), 'ALBAN ZAHER 6');
      expect(MerchantCleaner.clean('Carrefour Maadi'), 'Carrefour');
      expect(MerchantCleaner.clean('Spinneys GIZA T12'), 'Spinneys');
      expect(MerchantCleaner.clean('Cilantro ALEX'), 'Cilantro');
      expect(MerchantCleaner.clean('Cilantro Alexandria EG'), 'Cilantro');
      expect(MerchantCleaner.clean('Uber DOWNTOWN'), 'Uber');
      expect(MerchantCleaner.clean('Hyper One Dubai'), 'Hyper One');
    });

    test('the first word is never a suffix', () {
      expect(MerchantCleaner.clean('Cairo Kitchen'), 'Cairo Kitchen');
      expect(MerchantCleaner.clean('Giza Pharmacy Giza'), 'Giza Pharmacy');
    });

    test('keeps the original case', () {
      expect(MerchantCleaner.clean('McDonalds'), 'McDonalds');
      expect(MerchantCleaner.clean('GEIDEA kFc Cairo'), 'kFc');
    });

    test('a merchant that is only a processor is kept as it is', () {
      expect(MerchantCleaner.clean('FAWRY'), 'FAWRY');
      expect(MerchantCleaner.clean('POS'), 'POS');
    });

    test('drops trailing punctuation left behind', () {
      expect(MerchantCleaner.clean('Uber - Cairo'), 'Uber');
      expect(MerchantCleaner.clean('Uber*'), 'Uber');
    });

    test('Arabic names and cities', () {
      expect(MerchantCleaner.clean('كارفور القاهرة 12'), 'كارفور');
      expect(MerchantCleaner.clean('سبينيس'), 'سبينيس');
    });

    test('nothing, or only space, is null', () {
      expect(MerchantCleaner.clean(null), isNull);
      expect(MerchantCleaner.clean(''), isNull);
      expect(MerchantCleaner.clean('   '), isNull);
    });

    test('is at most 100 characters, the title limit', () {
      expect(MerchantCleaner.clean('A' * 150)!.length, MerchantCleaner.maxLength);
    });
  });

  group('MerchantCleaner.tidy', () {
    test('only collapses whitespace, so a name keeps its asterisks', () {
      expect(MerchantCleaner.tidy('  NADA   MOHAMED  ABDELM** '), 'NADA MOHAMED ABDELM**');
      expect(MerchantCleaner.tidy('  '), isNull);
      expect(MerchantCleaner.tidy(null), isNull);
    });
  });

  group('MerchantKey', () {
    test('is lower case with single spaces and no punctuation', () {
      expect(MerchantKey.of('Uber'), 'uber');
      expect(MerchantKey.of('ALBAN  ZAHER 6'), 'alban zaher 6');
      expect(MerchantKey.of("McDonald's*Cairo"), 'mcdonald s cairo');
      expect(MerchantKey.of('كارفور'), 'كارفور');
    });

    test('nothing left is null', () {
      expect(MerchantKey.of(null), isNull);
      expect(MerchantKey.of(' ** '), isNull);
    });

    test('is the same for the purchase and its cancellation', () {
      expect(MerchantKey.of('Uber'), MerchantKey.of('UBER'));
    });
  });
}
