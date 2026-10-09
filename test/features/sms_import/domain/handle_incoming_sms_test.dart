import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/usecases/delete_expense.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_outcome.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/usecases/handle_incoming_sms.dart';
import 'package:mocktail/mocktail.dart';

import '../sms_test_kit.dart';
import 'egbank_samples.dart';

void main() {
  final received = DateTime(2026, 10, 9, 15, 20, 30);
  late SmsTestKit kit;

  setUp(() => kit = SmsTestKit(now: () => DateTime(2026, 10, 9, 16)));
  tearDown(() => kit.close());

  RawSms sms(String body, {String sender = 'EGBANK', DateTime? at}) =>
      RawSms(sender: sender, body: body, receivedAt: at ?? received);

  Future<SmsOutcome> handle(RawSms message) async {
    final result = await kit.handle(message);
    return result.getOrElse((failure) => throw StateError('failed: $failure'));
  }

  Future<List<SmsImport>> imports() async => (await kit.imports.watchRecent(since: DateTime(2020)).first).getOrElse(
    (_) => const [],
  );

  group('Automatic mode', () {
    test('saves a confident purchase to the default wallet, once', () async {
      final message = sms(EgBankSamples.purchaseGeidea);

      final outcome = await handle(message);

      expect(outcome, isA<SmsRecorded>());
      final expenses = await kit.allExpenses();
      expect(expenses, hasLength(1));
      final expense = expenses.single;
      expect(expense.amountMinor, 14337);
      expect(expense.walletId, 1);
      expect(expense.title, 'ALBAN ZAHER 6');
      expect(expense.note, 'EG Bank ••9033');
      expect(expense.date.toIso(), '2026-10-09');
      expect(expense.source, 'sms');
      expect(expense.categoryId, await kit.category('other'));

      final import = (await imports()).single;
      expect(import.status, SmsImportStatus.added);
      expect(import.expenseId, expense.id);
      expect(import.smsKey, message.key);
      expect(import.sender, 'EGBANK');
      expect(import.cardLast4, '9033');
    });

    test('is idempotent: the same message, delivered again, adds nothing', () async {
      final message = sms(EgBankSamples.purchaseGeidea);

      await handle(message);
      final again = await handle(message);

      expect(again, isA<SmsIgnored>().having((o) => o.reason, 'reason', SmsIgnoreReason.duplicate));
      expect(await kit.allExpenses(), hasLength(1));
      expect(await imports(), hasLength(1));
    });

    test('two different messages with the same text are two transactions', () async {
      await handle(sms(EgBankSamples.purchaseGeidea));
      await handle(sms(EgBankSamples.purchaseGeidea, at: received.add(const Duration(minutes: 3))));

      expect(await kit.allExpenses(), hasLength(2));
    });

    test('the date of the text, the keyword category and the income kind', () async {
      await handle(sms(EgBankSamples.instaPayCredit));
      await handle(sms(EgBankSamples.purchaseUber));

      final expenses = await kit.allExpenses();
      final income = expenses.firstWhere((e) => e.amountMinor == 20000);
      expect(income.date.toIso(), '2026-10-07');
      expect(income.title, 'NADA MOHAMED ABDELM**');
      expect(income.note, 'InstaPay · Ref 65520277090');
      expect(income.categoryId, await kit.category('other_income'));
      final uber = expenses.firstWhere((e) => e.amountMinor == 500);
      expect(uber.title, 'Uber');
      expect(uber.categoryId, await kit.category('transport'));
    });

    test('uses the category the user chose for the merchant', () async {
      final food = await kit.category('food');
      await kit.imports.learn('uber', food);

      await handle(sms(EgBankSamples.purchaseUber));

      expect((await kit.allExpenses()).single.categoryId, food);
    });

    test('a message in another currency is never recorded: it asks', () async {
      kit.settings.currencyCode = 'USD';

      final outcome = await handle(sms(EgBankSamples.purchaseUber));

      expect(outcome, isA<SmsNeedsReview>().having((o) => o.otherCurrency, 'otherCurrency', isTrue));
      expect(await kit.allExpenses(), isEmpty);
      expect((await imports()).single.status, SmsImportStatus.pending);
    });

    test('a message the app is not confident about asks, even from a known bank', () async {
      final outcome = await handle(
        sms('Purchase of EGP 450.00 at Carrefour on card ending 1234', sender: 'CIB'),
      );

      expect(outcome, isA<SmsNeedsReview>().having((o) => o.otherCurrency, 'otherCurrency', isFalse));
      expect(await kit.allExpenses(), isEmpty);
    });

    test('with no default wallet it asks', () async {
      kit.settings.defaultWalletId = null;

      expect(await handle(sms(EgBankSamples.purchaseUber)), isA<SmsNeedsReview>());
      expect(await kit.allExpenses(), isEmpty);
    });

    test('a wallet that no longer exists is not an error: it asks', () async {
      kit.settings.defaultWalletId = 99;

      expect(await handle(sms(EgBankSamples.purchaseUber)), isA<SmsNeedsReview>());
      expect(await kit.allExpenses(), isEmpty);
    });
  });

  group('Ask mode', () {
    setUp(() => kit.settings.mode = SmsMode.ask);

    test('creates a pending import and no transaction', () async {
      final outcome = await handle(sms(EgBankSamples.purchaseUber));

      expect(outcome, isA<SmsNeedsReview>());
      final review = outcome as SmsNeedsReview;
      expect(review.otherCurrency, isFalse);
      expect(review.import.status, SmsImportStatus.pending);
      expect(review.import.amount, const Money(500));
      expect(review.import.merchant, 'Uber');
      expect(review.import.categoryId, await kit.category('transport'));
      expect(review.import.kind, TransactionKind.expense);
      expect(review.import.note, 'EG Bank ••9033');
      expect(review.import.date.toIso(), '2026-10-09');
      expect(await kit.allExpenses(), isEmpty);
    });

    test('is idempotent on the pending import', () async {
      final message = sms(EgBankSamples.purchaseUber);

      await handle(message);
      final again = await handle(message);

      expect(again, isA<SmsIgnored>());
      expect(await imports(), hasLength(1));
    });

    test('never stores the message body', () async {
      await handle(sms(EgBankSamples.purchaseUber));

      final rows = await kit.database.customSelect('SELECT * FROM sms_imports').get();
      final everything = rows.single.data.values.join(' ');
      expect(everything, isNot(contains('تم')));
      expect(everything, isNot(contains('Downtown')));
    });

    test('the pending import can be ignored, and then the transaction is never made', () async {
      final review = await handle(sms(EgBankSamples.purchaseUber)) as SmsNeedsReview;

      await kit.actions.ignore(review.import.id);

      expect((await imports()).single.status, SmsImportStatus.ignored);
      expect(await kit.allExpenses(), isEmpty);
    });

    test('ignoring does not undo an import that was added', () async {
      kit.settings.mode = SmsMode.auto;
      final recorded = await handle(sms(EgBankSamples.purchaseUber)) as SmsRecorded;

      await kit.actions.ignore(recorded.import.id);

      expect((await imports()).single.status, SmsImportStatus.added);
    });
  });

  group('messages that are dropped', () {
    test('everything, when SMS Import is off', () async {
      kit.settings.enabled = false;

      final outcome = await handle(sms(EgBankSamples.purchaseUber));

      expect(outcome, isA<SmsIgnored>().having((o) => o.reason, 'reason', SmsIgnoreReason.disabled));
      expect(await imports(), isEmpty);
      expect(await kit.allExpenses(), isEmpty);
    });

    test('OTP, declined and promotional messages, and they are not stored', () async {
      for (final body in [
        'Your OTP is 123456',
        'Your purchase of EGP 500 at Amazon was declined',
        'Get 20% off your next purchase at https://example.com/offer',
        'Your available balance is EGP 5,000',
      ]) {
        final outcome = await handle(sms(body, sender: 'CIB'));
        expect(outcome, isA<SmsIgnored>(), reason: body);
      }
      expect(await imports(), isEmpty);
      expect(await kit.allExpenses(), isEmpty);
    });

    test('a built-in sender that the user switched off', () async {
      await kit.actions.setSenderTrusted('EGBANK', trusted: false);

      final outcome = await handle(sms(EgBankSamples.purchaseUber));

      expect(outcome, isA<SmsIgnored>().having((o) => o.reason, 'reason', SmsIgnoreReason.untrusted));
      expect(await kit.allExpenses(), isEmpty);
    });

    test('switching it back on imports again', () async {
      await kit.actions.setSenderTrusted('EGBANK', trusted: false);
      await kit.actions.setSenderTrusted('egbank', trusted: true);

      expect(await handle(sms(EgBankSamples.purchaseUber)), isA<SmsRecorded>());
    });

    test('a phone number, however bank-like its text, is a person', () async {
      final outcome = await handle(sms('I paid EGP 500 at Amazon for you', sender: '+201001234567'));

      expect(outcome, isA<SmsIgnored>());
      expect(await imports(), isEmpty);
    });
  });

  group('cancellations', () {
    test('in Automatic mode delete the matching transaction and mark the import cancelled', () async {
      final recorded = await handle(sms(EgBankSamples.purchaseUber)) as SmsRecorded;
      expect(await kit.allExpenses(), hasLength(1));

      final outcome = await handle(sms(EgBankSamples.cancelUber, at: received.add(const Duration(hours: 2))));

      expect(outcome, isA<SmsImportCancelled>());
      expect((outcome as SmsImportCancelled).removedExpense, isTrue);
      expect(outcome.import.id, recorded.import.id);
      expect(await kit.allExpenses(), isEmpty);
      expect((await imports()).single.status, SmsImportStatus.cancelled);
    });

    test('with no matching purchase are ignored', () async {
      final outcome = await handle(sms(EgBankSamples.cancelUber));

      expect(outcome, isA<SmsIgnored>().having((o) => o.reason, 'reason', SmsIgnoreReason.noMatch));
      expect(await imports(), isEmpty);
    });

    test('do not match another card, amount, merchant or sender', () async {
      await handle(sms(EgBankSamples.purchaseUber));
      final later = received.add(const Duration(hours: 1));

      Future<void> expectNoMatch(String body, {String sender = 'EGBANK'}) async {
        final outcome = await handle(sms(body, sender: sender, at: later));
        expect(outcome, isA<SmsIgnored>(), reason: body);
      }

      // Another card, amount and merchant.
      await expectNoMatch(EgBankSamples.cancelUber.replaceAll('9033', '1111'));
      await expectNoMatch(EgBankSamples.cancelUber.replaceAll(' 5جم', ' 6جم'));
      await expectNoMatch(EgBankSamples.cancelUber.replaceAll('Uber', 'Careem'));
      expect(await kit.allExpenses(), hasLength(1));
      expect((await imports()).single.status, SmsImportStatus.added);
    });

    test('do not reach back more than 7 days', () async {
      await handle(sms(EgBankSamples.purchaseUber));

      final late = await handle(sms(EgBankSamples.cancelUber, at: received.add(const Duration(days: 8))));

      expect(late, isA<SmsIgnored>());
      expect(await kit.allExpenses(), hasLength(1));
    });

    test('match a purchase from 6 days ago', () async {
      await handle(sms(EgBankSamples.purchaseUber));
      final kit2 = kit;

      final outcome = await handle(sms(EgBankSamples.cancelUber, at: received.add(const Duration(days: 6))));

      expect(outcome, isA<SmsImportCancelled>());
      expect(await kit2.allExpenses(), isEmpty);
    });

    test('cancel only one purchase when two are alike, the latest', () async {
      await handle(sms(EgBankSamples.purchaseUber, at: received));
      await handle(sms(EgBankSamples.purchaseUber, at: received.add(const Duration(hours: 1))));

      await handle(sms(EgBankSamples.cancelUber, at: received.add(const Duration(hours: 2))));

      expect(await kit.allExpenses(), hasLength(1));
      final list = await imports();
      expect(list.where((i) => i.status == SmsImportStatus.cancelled), hasLength(1));
      expect(list.firstWhere((i) => i.status == SmsImportStatus.cancelled).receivedAt.hour, 16);
    });

    test('in Ask mode ask before removing a purchase that was added', () async {
      final recorded = await handle(sms(EgBankSamples.purchaseUber)) as SmsRecorded;
      kit.settings.mode = SmsMode.ask;

      final outcome = await handle(sms(EgBankSamples.cancelUber, at: received.add(const Duration(hours: 1))));

      expect(outcome, isA<SmsCancellationAsk>().having((o) => o.import.id, 'import', recorded.import.id));
      // Nothing is removed until the user says so.
      expect(await kit.allExpenses(), hasLength(1));
      expect((await imports()).single.status, SmsImportStatus.added);

      // "Remove".
      final removed = await kit.handle.cancelImport(recorded.import.id);
      expect(removed.getOrElse((_) => false), isTrue);
      expect(await kit.allExpenses(), isEmpty);
      expect((await imports()).single.status, SmsImportStatus.cancelled);
    });

    test('in Ask mode a purchase still pending is cancelled quietly', () async {
      kit.settings.mode = SmsMode.ask;
      final review = await handle(sms(EgBankSamples.purchaseUber)) as SmsNeedsReview;

      final outcome = await handle(sms(EgBankSamples.cancelUber, at: received.add(const Duration(hours: 1))));

      expect(outcome, isA<SmsImportCancelled>());
      expect((outcome as SmsImportCancelled).removedExpense, isFalse);
      expect(outcome.import.id, review.import.id);
      expect((await imports()).single.status, SmsImportStatus.cancelled);
    });

    test('removing a transaction the user already deleted is fine', () async {
      final recorded = await handle(sms(EgBankSamples.purchaseUber)) as SmsRecorded;
      await kit.expenses.delete(recorded.import.expenseId!);

      final removed = await kit.handle.cancelImport(recorded.import.id);

      expect(removed.getOrElse((_) => true), isFalse);
      expect((await imports()).single.status, SmsImportStatus.cancelled);
    });

    test('cancelling an import that is gone fails', () async {
      final removed = await kit.handle.cancelImport(404);

      expect(removed.swap().getOrElse((_) => throw StateError('no failure')), isA<NotFoundFailure>());
    });

    test('a cancellation from an untrusted sender is ignored', () async {
      final outcome = await handle(sms(EgBankSamples.cancelUber, sender: 'STRANGER'));

      expect(outcome, isA<SmsIgnored>());
    });
  });

  group('unknown senders', () {
    const body = 'Your account was debited with EGP 300 at Zara';

    test('a bank-like message asks to trust the sender, and waits', () async {
      final outcome = await handle(sms(body, sender: 'BANQUEMIS'));

      expect(outcome, isA<SmsTrustPrompt>());
      final prompt = outcome as SmsTrustPrompt;
      expect(prompt.sender, 'BANQUEMIS');
      expect(prompt.import.status, SmsImportStatus.pending);
      expect(prompt.import.amount, const Money(30000));
      // Not imported until trusted.
      expect(await kit.allExpenses(), isEmpty);
    });

    test('after Trust the sender is imported (it always asks: the parse is generic)', () async {
      await handle(sms(body, sender: 'BANQUEMIS'));
      await kit.actions.setSenderTrusted('BANQUEMIS', trusted: true);

      final outcome = await handle(sms('Your account was debited with EGP 120 at Noon', sender: 'BANQUEMIS'));

      expect(outcome, isA<SmsNeedsReview>());
      expect(await kit.allExpenses(), isEmpty);
    });

    test('after Ignore the sender never imports', () async {
      await handle(sms(body, sender: 'BANQUEMIS'));
      await kit.actions.setSenderTrusted('BANQUEMIS', trusted: false);

      final outcome = await handle(sms('Your account was debited with EGP 120 at Noon', sender: 'BANQUEMIS'));

      expect(outcome, isA<SmsIgnored>().having((o) => o.reason, 'reason', SmsIgnoreReason.untrusted));
    });

    test('a message that is not a transaction is not asked about', () async {
      final outcome = await handle(sms('Happy birthday from your friends at Zara', sender: 'ZARA'));

      expect(outcome, isA<SmsIgnored>());
      expect(await imports(), isEmpty);
    });

    test('the same message is asked about only once', () async {
      final message = sms(body, sender: 'BANQUEMIS');

      await handle(message);
      final again = await handle(message);

      expect(again, isA<SmsIgnored>());
      expect(await imports(), hasLength(1));
    });
  });

  group('failures', () {
    test('a storage failure comes back as a failure, not a crash', () async {
      final broken = _BrokenImports();
      final handler = HandleIncomingSms(
        settings: kit.settings,
        imports: broken,
        resolveCategory: kit.resolveCategory,
        saveExpense: kit.saveExpense,
        deleteExpense: DeleteExpense(kit.expenses),
      );

      final result = await handler(sms(EgBankSamples.purchaseUber));

      expect(result.swap().getOrElse((_) => throw StateError('no failure')), isA<StorageFailure>());
    });
  });

  test('the source of an automatic import is sms', () async {
    await handle(sms(EgBankSamples.purchaseUber));

    expect((await kit.allExpenses()).single.source, ExpenseSource.sms.name);
  });
}

/// An [ISmsImportRepository] whose every read fails.
class _BrokenImports extends Mock implements ISmsImportRepository {
  @override
  Future<Either<Failure, SmsImport?>> findByKey(String smsKey) async =>
      const Left(Failure.storage(message: 'disk full'));
}
