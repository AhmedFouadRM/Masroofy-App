import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_handler.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_payload.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notifier.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_outcome.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:mocktail/mocktail.dart';

import '../domain/egbank_samples.dart';
import '../sms_test_kit.dart';

class _MockNotifier extends Mock implements SmsNotifier {}

class _FakeImport extends Fake implements SmsImport {}

/// What the user does with the notifications: taps and buttons, with the real
/// database behind them and the notifier faked.
void main() {
  final received = DateTime(2026, 10, 9, 15, 20, 30);
  late SmsTestKit kit;
  late _MockNotifier notifier;
  late List<int> openedReviews;
  late List<int> openedExpenses;
  late SmsNotificationHandler handler;

  setUpAll(() => registerFallbackValue(_FakeImport()));

  setUp(() {
    kit = SmsTestKit(
      now: () => DateTime(2026, 10, 9, 16),
      settings: FakeSmsSettings(mode: SmsMode.ask),
    );
    notifier = _MockNotifier();
    when(() => notifier.dismissImport(any())).thenAnswer((_) async {});
    when(() => notifier.dismiss(any())).thenAnswer((_) async {});
    when(() => notifier.showReview(any(), otherCurrency: any(named: 'otherCurrency'))).thenAnswer((_) async {});
    openedReviews = [];
    openedExpenses = [];
    handler = SmsNotificationHandler(
      actions: kit.actions,
      handleIncoming: kit.handle,
      imports: kit.imports,
      settings: kit.settings,
      notifier: notifier,
      onOpenReview: openedReviews.add,
      onOpenExpense: openedExpenses.add,
    );
  });
  tearDown(() => kit.close());

  Future<SmsOutcome> receive(String body, {String sender = 'EGBANK', DateTime? at}) async =>
      (await kit.handle(RawSms(sender: sender, body: body, receivedAt: at ?? received))).getOrElse(
        (failure) => throw StateError('$failure'),
      );

  NotificationResponse response(SmsNotificationPayload payload, {String? action}) => NotificationResponse(
    notificationResponseType: action == null
        ? NotificationResponseType.selectedNotification
        : NotificationResponseType.selectedNotificationAction,
    id: payload.notificationId,
    actionId: action,
    payload: payload.encode(),
  );

  Future<List<SmsImport>> imports() async =>
      (await kit.imports.watchRecent(since: DateTime(2020)).first).getOrElse((_) => const []);

  group('a transaction to review', () {
    test('Add (or a tap) opens the pre-filled form', () async {
      final review = await receive(EgBankSamples.purchaseUber) as SmsNeedsReview;
      final payload = SmsNotificationPayload.review(review.import.id);

      await handler.handle(response(payload, action: SmsNotificationActions.add));
      await handler.handle(response(payload));

      expect(openedReviews, [review.import.id, review.import.id]);
      // Nothing is added until the form is saved.
      expect(await kit.allExpenses(), isEmpty);
      expect((await imports()).single.status, SmsImportStatus.pending);
    });

    test('Ignore ignores it, creates nothing and removes the notification', () async {
      final review = await receive(EgBankSamples.purchaseUber) as SmsNeedsReview;

      await handler.handle(
        response(SmsNotificationPayload.review(review.import.id), action: SmsNotificationActions.ignore),
      );

      expect((await imports()).single.status, SmsImportStatus.ignored);
      expect(await kit.allExpenses(), isEmpty);
      expect(openedReviews, isEmpty);
      verify(() => notifier.dismissImport(review.import.id)).called(1);
    });

    test('works without a UI: in a background isolate there is nothing to open', () async {
      final background = SmsNotificationHandler(
        actions: kit.actions,
        handleIncoming: kit.handle,
        imports: kit.imports,
        settings: kit.settings,
        notifier: notifier,
      );
      final review = await receive(EgBankSamples.purchaseUber) as SmsNeedsReview;

      await background.handle(
        response(SmsNotificationPayload.review(review.import.id), action: SmsNotificationActions.ignore),
      );

      expect((await imports()).single.status, SmsImportStatus.ignored);
    });
  });

  group('a cancelled purchase', () {
    late SmsImport added;

    setUp(() async {
      kit.settings.mode = SmsMode.auto;
      added = (await receive(EgBankSamples.purchaseUber) as SmsRecorded).import;
      kit.settings.mode = SmsMode.ask;
    });

    test('Remove deletes the transaction and marks the import cancelled', () async {
      expect(await kit.allExpenses(), hasLength(1));

      await handler.handle(
        response(SmsNotificationPayload.cancellation(added.id), action: SmsNotificationActions.remove),
      );

      expect(await kit.allExpenses(), isEmpty);
      expect((await imports()).single.status, SmsImportStatus.cancelled);
      verify(() => notifier.dismissImport(added.id)).called(1);
    });

    test('Keep leaves everything as it was', () async {
      await handler.handle(
        response(SmsNotificationPayload.cancellation(added.id), action: SmsNotificationActions.keep),
      );

      expect(await kit.allExpenses(), hasLength(1));
      expect((await imports()).single.status, SmsImportStatus.added);
      verify(() => notifier.dismissImport(added.id)).called(1);
    });

    test('a tap opens the transaction', () async {
      await handler.handle(response(SmsNotificationPayload.cancellation(added.id)));

      expect(openedExpenses, [added.expenseId ?? (await kit.allExpenses()).single.id]);
      expect(await kit.allExpenses(), hasLength(1));
    });
  });

  group('a sender to trust', () {
    const body = 'Your account was debited with EGP 300 at Zara';
    late SmsImport pending;

    setUp(() async {
      pending = (await receive(body, sender: 'BANQUEMIS') as SmsTrustPrompt).import;
    });

    test('Trust trusts the sender and asks about the message that prompted it', () async {
      await handler.handle(response(SmsNotificationPayload.trust(pending.id), action: SmsNotificationActions.trust));

      expect((await kit.imports.trustOf('BANQUEMIS')).getOrElse((_) => null), isTrue);
      verify(
        () => notifier.showReview(
          any(that: isA<SmsImport>().having((i) => i.id, 'id', pending.id)),
          otherCurrency: false,
        ),
      ).called(1);
      verify(() => notifier.dismiss(SmsNotificationPayload.trust(pending.id).notificationId)).called(1);
      // From now on its messages are imported.
      expect(
        await receive('Your account was debited with EGP 120 at Noon', sender: 'BANQUEMIS'),
        isA<SmsNeedsReview>(),
      );
    });

    test('a message in another currency is shown as such', () async {
      kit.settings.currencyCode = 'USD';

      await handler.handle(response(SmsNotificationPayload.trust(pending.id), action: SmsNotificationActions.trust));

      verify(() => notifier.showReview(any(), otherCurrency: true)).called(1);
    });

    test('Ignore blocks the sender for good and ignores the message', () async {
      await handler.handle(response(SmsNotificationPayload.trust(pending.id), action: SmsNotificationActions.distrust));

      expect((await kit.imports.trustOf('BANQUEMIS')).getOrElse((_) => null), isFalse);
      expect((await imports()).single.status, SmsImportStatus.ignored);
      verifyNever(() => notifier.showReview(any(), otherCurrency: any(named: 'otherCurrency')));
      expect(
        await receive('Your account was debited with EGP 120 at Noon', sender: 'BANQUEMIS'),
        isA<SmsIgnored>().having((o) => o.reason, 'reason', SmsIgnoreReason.untrusted),
      );
    });

    test('a tap just opens the app and decides nothing', () async {
      await handler.handle(response(SmsNotificationPayload.trust(pending.id)));

      expect((await kit.imports.trustOf('BANQUEMIS')).getOrElse((_) => null), isNull);
      expect(openedReviews, isEmpty);
    });
  });

  test('a notification that is not ours, or whose import is gone, is ignored', () async {
    await handler.handle(
      const NotificationResponse(
        notificationResponseType: NotificationResponseType.selectedNotification,
        payload: 'other:1',
      ),
    );
    await handler.handle(
      const NotificationResponse(notificationResponseType: NotificationResponseType.selectedNotification),
    );
    await handler.handle(response(const SmsNotificationPayload.review(404), action: SmsNotificationActions.ignore));
    await handler.handle(response(const SmsNotificationPayload.trust(404), action: SmsNotificationActions.trust));

    expect(openedReviews, isEmpty);
  });
}
