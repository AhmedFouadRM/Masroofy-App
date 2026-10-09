import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/sms_import/domain/usecases/resolve_category.dart';

import '../sms_test_kit.dart';

void main() {
  late SmsTestKit kit;

  setUp(() => kit = SmsTestKit());
  tearDown(() => kit.close());

  Future<int> resolve(String? merchant, {TransactionKind kind = TransactionKind.expense}) async =>
      (await kit.resolveCategory(merchant, kind)).getOrElse((failure) => throw StateError('$failure'));

  group('the order', () {
    test('learned first', () async {
      final shopping = await kit.category('shopping');
      await kit.imports.learn('uber', shopping);

      expect(await resolve('Uber'), shopping);
    });

    test('then the keyword list', () async {
      expect(await resolve('Uber'), await kit.category('transport'));
    });

    test('then Other for an expense and Other income for income', () async {
      expect(await resolve('Some Unknown Shop'), await kit.category('other'));
      expect(await resolve('Some Unknown Person', kind: TransactionKind.income), await kit.category('other_income'));
    });

    test('a message with no merchant is Other / Other income', () async {
      expect(await resolve(null), await kit.category('other'));
      expect(await resolve('  ', kind: TransactionKind.income), await kit.category('other_income'));
    });

    test('the learned choice is found whatever the case or punctuation of the merchant', () async {
      final health = await kit.category('health');
      await kit.imports.learn('alban zaher 6', health);

      expect(await resolve('ALBAN  ZAHER 6'), health);
      expect(await resolve('Alban Zaher 6*'), health);
    });

    test('a learned category of the other kind is not used', () async {
      final salary = await kit.category('salary');
      await kit.imports.learn('acme', salary);

      // As an expense, ACME is not a salary.
      expect(await resolve('ACME'), await kit.category('other'));
      expect(await resolve('ACME', kind: TransactionKind.income), salary);
    });

    test('a changed mind replaces the earlier choice', () async {
      await kit.imports.learn('uber', await kit.category('shopping'));
      await kit.imports.learn('uber', await kit.category('food'));

      expect(await resolve('Uber'), await kit.category('food'));
    });

    test('fails only when even the fallback is gone', () async {
      await kit.database.customStatement('DELETE FROM categories');

      expect((await kit.resolveCategory('Uber', TransactionKind.expense)).isLeft(), isTrue);
    });
  });

  group('the built-in keywords', () {
    final cases = <String, String>{
      'Uber': 'transport',
      'Careem': 'transport',
      'UBER TRIP': 'transport',
      'Carrefour': 'food',
      'Carrefour Maadi': 'food',
      'Spinneys': 'food',
      'Talabat': 'food',
      'Vodafone': 'bills',
      'Vodafone Egypt': 'bills',
      'WE': 'bills',
      'Etisalat': 'bills',
      'Orange': 'bills',
      'Amazon': 'shopping',
      'Netflix': 'entertainment',
      'Spotify': 'entertainment',
      'El Ezaby Pharmacy': 'health',
      'Udemy': 'education',
      'كارفور': 'food',
      'اوبر': 'transport',
      'فودافون': 'bills',
      'صيدلية العزبي': 'health',
    };

    for (final MapEntry(key: merchant, value: seedKey) in cases.entries) {
      test('$merchant is $seedKey', () async {
        expect(await resolve(merchant), await kit.category(seedKey));
      });
    }

    test('WE is a whole word: a weekend market is not a phone bill', () async {
      expect(await resolve('Weekend Gifts'), await kit.category('other'));
      expect(await resolve('Wecare Clinic'), await kit.category('health'));
    });

    test('income keywords', () async {
      expect(await resolve('ACME Salary', kind: TransactionKind.income), await kit.category('salary'));
      expect(await resolve('Amazon Refund', kind: TransactionKind.income), await kit.category('refunds'));
      // Carrefour is food, but money from it is not a food category.
      expect(await resolve('Carrefour', kind: TransactionKind.income), await kit.category('other_income'));
    });

    test('keywordSeedKey works on normalised names', () {
      expect(ResolveCategory.keywordSeedKey('uber', TransactionKind.expense), 'transport');
      expect(ResolveCategory.keywordSeedKey('nothing here', TransactionKind.expense), isNull);
    });
  });
}
