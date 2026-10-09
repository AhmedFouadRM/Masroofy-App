import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_texts.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notifier.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_outcome.dart';

/// The notifications SMS Import posts, with the platform channel of
/// `flutter_local_notifications` recorded instead of Android.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  late List<MethodCall> calls;
  late List<Map<String, Object?>> active;
  late SmsNotifier notifier;

  Map<String, dynamic> translations(String language) =>
      jsonDecode(File('assets/translations/$language.json').readAsStringSync()) as Map<String, dynamic>;

  void createNotifier(String language) {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    // What the generated plugin registrant does on a real Android device.
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    notifier = SmsNotifier(
      FlutterLocalNotificationsPlugin(),
      () async => SmsNotificationTexts.fromMap(translations(language), languageCode: language),
    );
  }

  setUp(() {
    calls = [];
    active = [];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return switch (call.method) {
        'getActiveNotifications' => active,
        _ => null,
      };
    });
    createNotifier('en');
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  SmsImport import({
    int id = 12,
    TransactionKind kind = TransactionKind.expense,
    int minor = 45000,
    String currency = 'EGP',
    String? merchant = 'Carrefour',
  }) => SmsImport(
    id: id,
    smsKey: 'k$id',
    sender: 'CIB',
    receivedAt: DateTime(2026, 10, 9),
    kind: kind,
    amount: Money(minor),
    currency: currency,
    date: LocalDate(2026, 10, 9),
    status: SmsImportStatus.pending,
    merchant: merchant,
  );

  List<MethodCall> shown() => calls.where((c) => c.method == 'show').toList();

  Map<Object?, Object?> arguments(MethodCall call) => call.arguments as Map<Object?, Object?>;

  Map<Object?, Object?> details(MethodCall call) => arguments(call)['platformSpecifics']! as Map<Object?, Object?>;

  List<String> actionTitles(MethodCall call) => [
    for (final action in (details(call)['actions'] as List?) ?? const []) (action as Map)['title']! as String,
  ];

  test('an expense to review: "EGP 450 at Carrefour", Add and Ignore', () async {
    await notifier.showReview(import(), otherCurrency: false);

    final call = shown().single;
    expect(arguments(call)['id'], 12);
    expect(arguments(call)['title'], 'EGP 450 at Carrefour');
    expect(arguments(call)['body'], 'Tap to add this expense');
    expect(arguments(call)['payload'], 'review:12');
    expect(details(call)['channelId'], SmsNotifier.transactionsChannelId);
    expect(details(call)['channelName'], 'Transactions from SMS');
    expect(actionTitles(call), ['Add', 'Ignore']);
    // Add opens the app; Ignore does not.
    final actions = (details(call)['actions']! as List).cast<Map<Object?, Object?>>();
    expect(actions.first['showsUserInterface'], isTrue);
    expect(actions.last['showsUserInterface'], isFalse);
  });

  test('an income to review', () async {
    await notifier.showReview(
      import(kind: TransactionKind.income, minor: 1200000, merchant: 'ACME'),
      otherCurrency: false,
    );

    expect(arguments(shown().single)['title'], 'EGP 12,000 from ACME');
    expect(arguments(shown().single)['body'], 'Tap to add this income');
  });

  test('with no merchant', () async {
    await notifier.showReview(import(merchant: null), otherCurrency: false);
    await notifier.showReview(import(id: 13, merchant: null, kind: TransactionKind.income), otherCurrency: false);

    expect(shown().map((c) => arguments(c)['title']), ['EGP 450 spent', 'EGP 450 received']);
  });

  test('a message in another currency: the body says to review it', () async {
    await notifier.showReview(import(minor: 2500, currency: 'USD', merchant: 'Amazon'), otherCurrency: true);

    final call = shown().single;
    expect(arguments(call)['title'], 'Transaction to review');
    expect(arguments(call)['body'], r'$25 at Amazon: tap to review');
  });

  test('follows the app language, not the message', () async {
    createNotifier('ar');

    await notifier.showReview(import(), otherCurrency: false);

    final call = shown().single;
    expect(arguments(call)['title'], '٤٥٠ ج.م. لدى Carrefour');
    expect(arguments(call)['body'], 'اضغط لإضافة هذا المصروف');
    expect(details(call)['channelName'], 'معاملات من الرسائل');
    expect(actionTitles(call), ['إضافة', 'تجاهل']);
  });

  test('a cancelled purchase: Remove and Keep', () async {
    await notifier.showCancellationAsk(import(id: 7, minor: 500, merchant: 'Uber'));

    final call = shown().single;
    expect(arguments(call)['id'], 1000007);
    expect(arguments(call)['title'], 'Purchase cancelled');
    expect(arguments(call)['body'], 'Uber purchase of EGP 5 was cancelled. Remove it?');
    expect(arguments(call)['payload'], 'cancellation:7');
    expect(actionTitles(call), ['Remove', 'Keep']);
  });

  test('a new sender: Trust and Ignore, on the senders channel', () async {
    await notifier.showTrustPrompt(import(id: 3).copyWith(sender: 'BANQUEMIS'));

    final call = shown().single;
    expect(arguments(call)['id'], 2000003);
    expect(arguments(call)['title'], 'Trust messages from BANQUEMIS?');
    expect(arguments(call)['payload'], 'trust:3');
    expect(details(call)['channelId'], SmsNotifier.sendersChannelId);
    expect(details(call)['channelName'], 'New SMS senders');
    expect(actionTitles(call), ['Trust', 'Ignore']);
  });

  test('a built-in sender is shown by its bank name', () async {
    await notifier.showTrustPrompt(import(id: 3));

    expect(arguments(shown().single)['title'], 'Trust messages from CIB?');
  });

  group('grouping', () {
    Map<String, Object?> activeReview(int id) => {'id': id, 'groupKey': SmsNotifier.groupKey};

    test('fewer than 3 review notifications are not grouped under a summary', () async {
      active = [activeReview(1), activeReview(2)];

      await notifier.showReview(import(id: 2), otherCurrency: false);

      expect(shown(), hasLength(1));
    });

    test('3 or more get a summary', () async {
      active = [activeReview(1), activeReview(2), activeReview(3)];

      await notifier.showReview(import(id: 3), otherCurrency: false);

      final summary = shown().last;
      expect(arguments(summary)['id'], 3000000);
      expect(arguments(summary)['title'], '3 transactions to review');
      expect(details(summary)['setAsGroupSummary'], isTrue);
      expect(details(summary)['groupKey'], SmsNotifier.groupKey);
    });

    test('the summary is not counted among the notifications it summarises', () async {
      active = [
        activeReview(1),
        activeReview(2),
        {'id': 3000000, 'groupKey': SmsNotifier.groupKey},
      ];

      await notifier.showReview(import(id: 2), otherCurrency: false);

      expect(shown(), hasLength(1));
    });

    test('the summary goes when fewer are left', () async {
      active = [
        activeReview(1),
        {'id': 3000000, 'groupKey': SmsNotifier.groupKey},
      ];

      await notifier.dismissImport(2);

      expect(
        calls.where((c) => c.method == 'cancel').map((c) => arguments(c)['id']),
        containsAll([2, 1000002, 2000002, 3000000]),
      );
    });
  });

  group('announce', () {
    test('posts what each outcome calls for', () async {
      await notifier.announce(SmsNeedsReview(import(), otherCurrency: false));
      await notifier.announce(SmsCancellationAsk(import(id: 5)));
      await notifier.announce(SmsTrustPrompt('BANQUEMIS', import(id: 6)));

      expect(shown().map((c) => arguments(c)['payload']), ['review:12', 'cancellation:5', 'trust:6']);
    });

    test('shows nothing for a recorded or ignored message', () async {
      await notifier.announce(SmsRecorded(import()));
      await notifier.announce(const SmsIgnored(SmsIgnoreReason.notTransaction));

      expect(shown(), isEmpty);
    });

    test('a cancelled import takes its notifications away', () async {
      await notifier.announce(SmsImportCancelled(import(id: 9), removedExpense: false));

      expect(calls.where((c) => c.method == 'cancel').map((c) => arguments(c)['id']), containsAll([9, 1000009]));
    });
  });
}
