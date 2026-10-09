import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_outcome.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_sender_entry.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/usecases/list_sms_senders.dart';

import '../sms_test_kit.dart';
import 'egbank_samples.dart';

void main() {
  final received = DateTime(2026, 10, 9, 15, 20, 30);
  late SmsTestKit kit;

  setUp(() => kit = SmsTestKit(now: () => DateTime(2026, 10, 9, 16)));
  tearDown(() => kit.close());

  Future<SmsImport> pendingUber() async {
    kit.settings.mode = SmsMode.ask;
    final outcome = (await kit.handle(
      RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: received),
    )).getOrElse((_) => throw StateError('failed'));
    return (outcome as SmsNeedsReview).import;
  }

  group('SmsImportActions.complete', () {
    test('marks the import added, links the transaction and learns the merchant category', () async {
      final import = await pendingUber();
      final food = await kit.category('food');
      final expenseId = await kit.addManual(amountMinor: 500, date: received.toLocalDate());

      final result = await kit.actions.complete(import.id, expenseId: expenseId, categoryId: food);

      expect(result.isRight(), isTrue);
      final done = (await kit.imports.getById(import.id)).getOrElse((_) => throw StateError('gone'));
      expect(done.status, SmsImportStatus.added);
      expect(done.expenseId, expenseId);
      // The next message from the merchant uses the category the user chose.
      expect((await kit.resolveCategory('Uber', done.kind)).getOrElse((_) => -1), food);
    });

    test('works on an import the user had ignored', () async {
      final import = await pendingUber();
      await kit.actions.ignore(import.id);
      final expenseId = await kit.addManual(amountMinor: 500, date: received.toLocalDate());

      await kit.actions.complete(import.id, expenseId: expenseId, categoryId: await kit.category('other'));

      expect(
        (await kit.imports.getById(import.id)).getOrElse((_) => throw StateError('gone')).status,
        SmsImportStatus.added,
      );
    });

    test('an import with no merchant learns nothing', () async {
      kit.settings.mode = SmsMode.ask;
      final outcome =
          (await kit.handle(
                RawSms(sender: 'EGBANK', body: EgBankSamples.instaPayDebit, receivedAt: received),
              )).getOrElse((_) => throw StateError('failed'))
              as SmsNeedsReview;
      final expenseId = await kit.addManual(amountMinor: 26000, date: received.toLocalDate());

      final result = await kit.actions.complete(
        outcome.import.id,
        expenseId: expenseId,
        categoryId: await kit.category('food'),
      );

      expect(result.isRight(), isTrue);
      expect(await kit.database.customSelect('SELECT * FROM merchant_categories').get(), isEmpty);
    });

    test('fails for an import that is gone', () async {
      final result = await kit.actions.complete(404, expenseId: 1, categoryId: 1);

      expect(result.swap().getOrElse((_) => throw StateError('no failure')), isA<NotFoundFailure>());
    });

    test('fails for an import that is gone: ignore too', () async {
      expect((await kit.actions.ignore(404)).isLeft(), isTrue);
    });
  });

  group('SmsImportActions.deleteHistory', () {
    test('clears the imports and keeps the transactions', () async {
      kit.settings.mode = SmsMode.auto;
      await kit.handle(RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: received));
      await kit.actions.setSenderTrusted('ZARA', trusted: true);

      await kit.actions.deleteHistory();

      expect(await kit.database.customSelect('SELECT * FROM sms_imports').get(), isEmpty);
      expect(await kit.allExpenses(), hasLength(1));
      // The user's answers are not history.
      expect((await kit.imports.trustOf('ZARA')).getOrElse((_) => null), isTrue);
    });

    test('lets a re-scan offer the messages again, flagged as likely duplicates', () async {
      await kit.handle(
        RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: DateTime(2026, 10, 8, 12)),
      );
      await kit.actions.deleteHistory();
      kit.inbox.messages = [
        RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: DateTime(2026, 10, 8, 12)),
      ];

      final candidates = (await kit.importRecent()).getOrElse((_) => const []);

      expect(candidates.single.likelyDuplicate, isTrue);
    });
  });

  group('ListSmsSenders', () {
    Future<List<SmsSenderEntry>> list() async =>
        (await ListSmsSenders(imports: kit.imports, inbox: kit.inbox, now: () => received)(
          (await kit.imports.trusted()).getOrElse((_) => const {}),
        )).getOrElse((_) => const []);

    test('lists the built-in senders found in the inbox, on', () async {
      kit.inbox.messages = [
        RawSms(sender: 'CIB', body: 'x', receivedAt: DateTime(2026, 10)),
        RawSms(sender: 'Vodafone-Cash', body: 'x', receivedAt: DateTime(2026, 10)),
        RawSms(sender: 'CIB', body: 'y', receivedAt: DateTime(2026, 10, 2)),
        // A stranger that was never asked about is not listed.
        RawSms(sender: 'SOMEONE', body: 'z', receivedAt: DateTime(2026, 10, 2)),
      ];

      final senders = await list();

      expect(senders.map((s) => s.name), ['CIB', 'Vodafone Cash']);
      expect(senders.every((s) => s.trusted && !s.addedByUser), isTrue);
      expect(senders.last.type, SmsSenderType.wallet);
    });

    test('lists senders already imported from even when the inbox is empty', () async {
      await kit.handle(RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: received));

      expect((await list()).map((s) => s.name), ['EG Bank']);
    });

    test('shows the switch of a sender the user turned off, and the ones the user trusted, last', () async {
      kit.inbox.messages = [
        RawSms(sender: 'CIB', body: 'x', receivedAt: DateTime(2026, 10)),
        RawSms(sender: 'NBE', body: 'x', receivedAt: DateTime(2026, 10)),
      ];
      await kit.actions.setSenderTrusted('NBE', trusted: false);
      await kit.actions.setSenderTrusted('BANQUEMIS', trusted: true);

      final senders = await list();

      expect(senders.map((s) => (s.name, s.trusted, s.addedByUser)), [
        ('CIB', true, false),
        ('NBE', false, false),
        ('BANQUEMIS', true, true),
      ]);
    });

    test('a built-in sender with an answer but nothing in the inbox is still listed', () async {
      await kit.actions.setSenderTrusted('Instapay', trusted: false);

      final senders = await list();

      expect(senders.single.name, 'InstaPay');
      expect(senders.single.trusted, isFalse);
      expect(senders.single.type, SmsSenderType.instant);
    });

    test('survives an unreadable inbox', () async {
      kit.inbox.failure = const Failure.unexpected(error: 'no permission');
      await kit.actions.setSenderTrusted('BANQUEMIS', trusted: true);

      expect((await list()).single.name, 'BANQUEMIS');
    });
  });

  group('SenderCatalog', () {
    test('finds a sender by any alias, however it is written', () {
      expect(SenderCatalog.lookup('EGBANK')?.name, 'EG Bank');
      expect(SenderCatalog.lookup('eg-bank')?.name, 'EG Bank');
      expect(SenderCatalog.lookup('CIB-EG')?.name, 'CIB');
      expect(SenderCatalog.lookup('Vodafone Cash')?.name, 'Vodafone Cash');
      expect(SenderCatalog.lookup('VFCASH')?.name, 'Vodafone Cash');
      expect(SenderCatalog.lookup('AlRajhi')?.name, 'Al Rajhi');
    });

    test('does not know strangers or empty names', () {
      expect(SenderCatalog.lookup('SOMEONE'), isNull);
      expect(SenderCatalog.lookup(''), isNull);
      expect(SenderCatalog.lookup('---'), isNull);
      expect(SenderCatalog.isKnown('CIBX'), isFalse);
    });

    test('the PRD list is in the catalog', () {
      for (final name in [
        'EG Bank',
        'CIB',
        'NBE',
        'Banque Misr',
        'QNB',
        'Banque du Caire',
        'AAIB',
        'HSBC',
        'Vodafone Cash',
        'InstaPay',
        'Fawry',
        'Orange Cash',
        'Etisalat Cash',
        'Al Rajhi',
        'SNB',
        'Riyad Bank',
        'STC Pay',
        'Emirates NBD',
        'ADCB',
      ]) {
        expect(SenderCatalog.senders.map((s) => s.name), contains(name));
      }
    });

    test('ids and aliases are unique', () {
      final ids = SenderCatalog.senders.map((s) => s.id);
      expect(ids.toSet(), hasLength(ids.length));
      final aliases = SenderCatalog.senders.expand((s) => s.aliases).toList();
      expect(aliases.toSet(), hasLength(aliases.length));
      for (final alias in aliases) {
        expect(SenderCatalog.normalize(alias), alias);
      }
    });

    test('every alias of a sender shares one key', () {
      expect(SenderCatalog.keyOf('CIB'), SenderCatalog.keyOf('cibeg'));
      expect(SenderCatalog.keyOf('BANQUEMIS'), 'BANQUEMIS');
    });

    test('a phone number is personal; a name or a short code is not', () {
      expect(SenderCatalog.looksPersonal('+201001234567'), isTrue);
      expect(SenderCatalog.looksPersonal('01001234567'), isTrue);
      expect(SenderCatalog.looksPersonal('CIB'), isFalse);
      expect(SenderCatalog.looksPersonal('15060'), isFalse);
    });

    test('the display name is the bank, or the address', () {
      expect(SenderCatalog.displayName('egbank'), 'EG Bank');
      expect(SenderCatalog.displayName(' ZARA '), 'ZARA');
    });
  });

  group('RawSms.key', () {
    final base = RawSms(sender: 'EGBANK', body: 'hello', receivedAt: DateTime(2026, 10, 9, 15));

    test('is the same for the same message', () {
      expect(base.key, RawSms(sender: 'EGBANK', body: 'hello', receivedAt: DateTime(2026, 10, 9, 15)).key);
      expect(base.key, hasLength(64));
    });

    test('changes with the sender, the time and the body', () {
      expect(base.key, isNot(RawSms(sender: 'CIB', body: 'hello', receivedAt: base.receivedAt).key));
      expect(base.key, isNot(RawSms(sender: 'EGBANK', body: 'hello!', receivedAt: base.receivedAt).key));
      expect(base.key, isNot(RawSms(sender: 'EGBANK', body: 'hello', receivedAt: DateTime(2026, 10, 9, 15, 0, 1)).key));
    });

    test('does not contain the body', () {
      expect(base.key, isNot(contains('hello')));
    });
  });
}

extension on DateTime {
  /// The device-local date.
  LocalDate toLocalDate() => LocalDate.fromDateTime(this);
}
