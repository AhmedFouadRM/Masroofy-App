import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/domain/entities/catch_up_candidate.dart';
import 'package:masroofy/features/sms_import/domain/entities/parsed_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_outcome.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';

import '../sms_test_kit.dart';
import 'egbank_samples.dart';

void main() {
  /// The phone's clock: Oct 9, 2026.
  final now = DateTime(2026, 10, 9, 18);
  late SmsTestKit kit;

  setUp(() => kit = SmsTestKit(now: () => now));
  tearDown(() => kit.close());

  RawSms sms(String body, {required DateTime at, String sender = 'EGBANK'}) =>
      RawSms(sender: sender, body: body, receivedAt: at);

  Future<List<CatchUpCandidate>> scan() async =>
      (await kit.importRecent()).getOrElse((failure) => throw StateError('$failure'));

  group('ImportRecent', () {
    test('lists the transactions of the last 30 days, newest first', () async {
      kit.inbox.messages = [
        sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 12)),
        sms(EgBankSamples.purchaseGeidea, at: DateTime(2026, 10, 9, 9)),
        sms(EgBankSamples.instaPayCredit, at: DateTime(2026, 10, 7, 14, 40)),
        // Older than 30 days.
        sms(EgBankSamples.instaPayDebit, at: DateTime(2026, 9, 5, 12)),
      ];

      final candidates = await scan();

      expect(candidates.map((c) => c.parsed.merchant), ['ALBAN ZAHER 6', 'Uber', 'NADA MOHAMED ABDELM**']);
      expect(candidates.first.parsed.amount, const Money(14337));
      expect(candidates.first.categoryId, await kit.category('other'));
      expect(candidates[1].categoryId, await kit.category('transport'));
      expect(candidates.last.parsed.kind, SmsKind.income);
      expect(candidates.every((c) => !c.likelyDuplicate), isTrue);
      expect(candidates.first.smsKey, sms(EgBankSamples.purchaseGeidea, at: DateTime(2026, 10, 9, 9)).key);
    });

    test('writes nothing', () async {
      kit.inbox.messages = [sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 12))];

      await scan();

      expect(await kit.allExpenses(), isEmpty);
      expect((await kit.imports.watchRecent(since: DateTime(2020)).first).getOrElse((_) => const []), isEmpty);
    });

    test('leaves out OTP, declined and promotional messages', () async {
      kit.inbox.messages = [
        sms('Your OTP is 123456', sender: 'CIB', at: DateTime(2026, 10, 8)),
        sms('Purchase of EGP 500 at Amazon was declined', sender: 'CIB', at: DateTime(2026, 10, 8)),
        sms('Get 20% off, apply now at https://x.example', sender: 'CIB', at: DateTime(2026, 10, 8)),
      ];

      expect(await scan(), isEmpty);
    });

    test('reads only built-in and trusted senders', () async {
      const body = 'Your account was debited with EGP 300 at Zara';
      kit.inbox.messages = [
        sms(body, sender: 'BANQUEMIS', at: DateTime(2026, 10, 8)),
        sms(body, sender: 'ZARASTORE', at: DateTime(2026, 10, 8)),
        sms('Purchase of EGP 450 at Carrefour, card ending 1234', sender: 'CIB', at: DateTime(2026, 10, 8)),
      ];
      await kit.actions.setSenderTrusted('BANQUEMIS', trusted: true);
      await kit.actions.setSenderTrusted('ZARASTORE', trusted: false);

      final candidates = await scan();

      expect(candidates.map((c) => c.sender), unorderedEquals(['BANQUEMIS', 'CIB']));
    });

    test('leaves out messages that are already imported, in any status', () async {
      final added = sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 12));
      final ignored = sms(EgBankSamples.purchaseGeidea, at: DateTime(2026, 10, 9, 9));
      final fresh = sms(EgBankSamples.instaPayCredit, at: DateTime(2026, 10, 7, 14, 40));
      kit.inbox.messages = [added, ignored, fresh];
      await kit.handle(added);
      kit.settings.mode = SmsMode.ask;
      final pending = (await kit.handle(ignored)).getOrElse((_) => throw StateError('failed')) as SmsNeedsReview;
      await kit.actions.ignore(pending.import.id);

      final candidates = await scan();

      expect(candidates.single.smsKey, fresh.key);
    });

    test('leaves out a purchase that its cancellation also cancels', () async {
      kit.inbox.messages = [
        sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 12)),
        sms(EgBankSamples.cancelUber, at: DateTime(2026, 10, 8, 12, 5)),
        sms(EgBankSamples.purchaseGeidea, at: DateTime(2026, 10, 9, 9)),
      ];

      final candidates = await scan();

      expect(candidates.map((c) => c.parsed.merchant), ['ALBAN ZAHER 6']);
    });

    test('a cancellation takes away only one of two alike purchases', () async {
      kit.inbox.messages = [
        sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 9)),
        sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 11)),
        sms(EgBankSamples.cancelUber, at: DateTime(2026, 10, 8, 12)),
      ];

      final candidates = await scan();

      expect(candidates, hasLength(1));
      expect(candidates.single.receivedAt.hour, 9);
    });

    test('a cancellation with no purchase in the inbox changes nothing', () async {
      kit.inbox.messages = [
        sms(EgBankSamples.cancelUber, at: DateTime(2026, 10, 8, 12)),
        sms(EgBankSamples.purchaseGeidea, at: DateTime(2026, 10, 9, 9)),
      ];

      expect(await scan(), hasLength(1));
    });

    test('leaves out messages in another currency', () async {
      kit.inbox.messages = [
        sms('Purchase of USD 25.50 at Amazon, card ending 1234', sender: 'CIB', at: DateTime(2026, 10, 8)),
      ];

      expect(await scan(), isEmpty);
    });

    test('is empty when the inbox is empty', () async {
      expect(await scan(), isEmpty);
    });

    test('fails when the inbox cannot be read', () async {
      kit.inbox.failure = const Failure.unexpected(error: 'no permission');

      expect((await kit.importRecent()).isLeft(), isTrue);
    });
  });

  group('likely duplicates', () {
    Future<CatchUpCandidate> candidateOf(String body, DateTime at) async {
      kit.inbox.messages = [sms(body, at: at)];
      return (await scan()).single;
    }

    test('a manual transaction with the same amount, kind and date', () async {
      await kit.addManual(amountMinor: 500, date: LocalDate(2026, 10, 8));

      expect((await candidateOf(EgBankSamples.purchaseUber, DateTime(2026, 10, 8, 12))).likelyDuplicate, isTrue);
    });

    test('a day before or after still counts', () async {
      await kit.addManual(amountMinor: 500, date: LocalDate(2026, 10, 7));
      expect((await candidateOf(EgBankSamples.purchaseUber, DateTime(2026, 10, 8, 12))).likelyDuplicate, isTrue);
      await kit.database.customStatement('DELETE FROM expenses');
      await kit.addManual(amountMinor: 500, date: LocalDate(2026, 10, 9));
      expect((await candidateOf(EgBankSamples.purchaseUber, DateTime(2026, 10, 8, 12))).likelyDuplicate, isTrue);
    });

    test('two days away does not', () async {
      await kit.addManual(amountMinor: 500, date: LocalDate(2026, 10, 6));

      expect((await candidateOf(EgBankSamples.purchaseUber, DateTime(2026, 10, 8, 12))).likelyDuplicate, isFalse);
    });

    test('another amount or kind does not', () async {
      await kit.addManual(amountMinor: 501, date: LocalDate(2026, 10, 8));
      await kit.addManual(amountMinor: 500, date: LocalDate(2026, 10, 8), kind: TransactionKind.income);

      expect((await candidateOf(EgBankSamples.purchaseUber, DateTime(2026, 10, 8, 12))).likelyDuplicate, isFalse);
    });

    test('an income candidate matches an income transaction', () async {
      await kit.addManual(amountMinor: 20000, date: LocalDate(2026, 10, 7), kind: TransactionKind.income);

      expect((await candidateOf(EgBankSamples.instaPayCredit, DateTime(2026, 10, 7, 14, 40))).likelyDuplicate, isTrue);
    });

    test('a transaction generated from a template is not a manual one', () async {
      await kit.addManual(amountMinor: 500, date: LocalDate(2026, 10, 8), source: ExpenseSource.recurring);

      expect((await candidateOf(EgBankSamples.purchaseUber, DateTime(2026, 10, 8, 12))).likelyDuplicate, isFalse);
    });

    test('an earlier SMS import of the same amount counts too (a re-scan after deleting the history)', () async {
      await kit.addManual(amountMinor: 500, date: LocalDate(2026, 10, 8), source: ExpenseSource.sms);

      expect((await candidateOf(EgBankSamples.purchaseUber, DateTime(2026, 10, 8, 12))).likelyDuplicate, isTrue);
    });
  });

  group('AddCatchUpSelection', () {
    test('adds the selected candidates to the default wallet with source sms', () async {
      kit.inbox.messages = [
        sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 12)),
        sms(EgBankSamples.purchaseGeidea, at: DateTime(2026, 10, 9, 9)),
        sms(EgBankSamples.instaPayCredit, at: DateTime(2026, 10, 7, 14, 40)),
      ];
      final candidates = await scan();

      final added = await kit.addCatchUp([candidates[0], candidates[2]]);

      expect(added.getOrElse((_) => -1), 2);
      final expenses = await kit.allExpenses();
      expect(expenses, hasLength(2));
      expect(expenses.every((e) => e.source == 'sms' && e.walletId == 1), isTrue);
      expect(expenses.map((e) => e.amountMinor), unorderedEquals([14337, 20000]));
      final geidea = expenses.firstWhere((e) => e.amountMinor == 14337);
      expect(geidea.title, 'ALBAN ZAHER 6');
      expect(geidea.note, 'EG Bank ••9033');
      final income = expenses.firstWhere((e) => e.amountMinor == 20000);
      expect(income.date.toIso(), '2026-10-07');
      expect(income.categoryId, await kit.category('other_income'));
    });

    test('goes to the default wallet in either mode', () async {
      for (final mode in SmsMode.values) {
        await kit.database.customStatement('DELETE FROM expenses');
        await kit.database.customStatement('DELETE FROM sms_imports');
        kit.settings.mode = mode;
        kit.inbox.messages = [sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 12))];

        await kit.addCatchUp(await scan());

        expect(await kit.allExpenses(), hasLength(1), reason: mode.name);
      }
    });

    test('adds nothing twice: a second scan offers nothing, and adding again changes nothing', () async {
      kit.inbox.messages = [sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 12))];
      final candidates = await scan();

      await kit.addCatchUp(candidates);
      final again = await kit.addCatchUp(candidates);

      expect(again.getOrElse((_) => -1), 0);
      expect(await kit.allExpenses(), hasLength(1));
      expect(await scan(), isEmpty);
    });

    test('records each as an added import', () async {
      kit.inbox.messages = [sms(EgBankSamples.purchaseUber, at: DateTime(2026, 10, 8, 12))];

      await kit.addCatchUp(await scan());

      final import = (await kit.imports.watchRecent(since: DateTime(2020)).first).getOrElse((_) => const []).single;
      expect(import.status, SmsImportStatus.added);
      expect(import.expenseId, (await kit.allExpenses()).single.id);
    });

    test('adds nothing when none is selected', () async {
      expect((await kit.addCatchUp(const [])).getOrElse((_) => -1), 0);
    });

    test('fails without a default wallet', () async {
      kit.settings.defaultWalletId = null;

      expect((await kit.addCatchUp(const [])).isLeft(), isTrue);
    });
  });
}
