import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_payload.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_texts.dart';
import 'package:masroofy/features/sms_import/data/platform/sms_channel.dart';
import 'package:masroofy/features/sms_import/data/sms_settings_store.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The real translation files, as an asset bundle.
class _FileBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(key).readAsBytes();
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SmsNotificationPayload', () {
    test('round-trips each kind', () {
      for (final payload in [
        const SmsNotificationPayload.review(12),
        const SmsNotificationPayload.cancellation(7),
        const SmsNotificationPayload.trust(3),
      ]) {
        expect(SmsNotificationPayload.tryParse(payload.encode()), payload);
      }
      expect(const SmsNotificationPayload.review(12).encode(), 'review:12');
    });

    test('is not fooled by other payloads', () {
      expect(SmsNotificationPayload.tryParse(null), isNull);
      expect(SmsNotificationPayload.tryParse(''), isNull);
      expect(SmsNotificationPayload.tryParse('review'), isNull);
      expect(SmsNotificationPayload.tryParse('review:x'), isNull);
      expect(SmsNotificationPayload.tryParse('other:5'), isNull);
      expect(SmsNotificationPayload.tryParse('review:1:2'), isNull);
    });

    test('the three kinds never share a notification id', () {
      final ids = {
        for (final payload in [
          const SmsNotificationPayload.review(5),
          const SmsNotificationPayload.cancellation(5),
          const SmsNotificationPayload.trust(5),
        ])
          payload.notificationId,
      };
      expect(ids, hasLength(3));
      expect(const SmsNotificationPayload.review(5).notificationId, 5);
    });
  });

  group('SmsNotificationTexts', () {
    Map<String, dynamic> translations(String language) =>
        jsonDecode(File('assets/translations/$language.json').readAsStringSync()) as Map<String, dynamic>;

    test('reads a string by its dotted key and fills each {} in order', () {
      final texts = SmsNotificationTexts.fromMap(translations('en'));

      expect(texts.t('sms.notification.add'), 'Add');
      expect(texts.t('sms.notification.expense_at', ['EGP 450', 'Carrefour']), 'EGP 450 at Carrefour');
      expect(texts.t('sms.notification.tap_expense'), 'Tap to add this expense');
      expect(texts.t('sms.other_currency', ['USD 25 at Amazon']), 'USD 25 at Amazon: tap to review');
      expect(
        texts.t('sms.notification.cancelled_body', ['Uber', 'EGP 5']),
        'Uber purchase of EGP 5 was cancelled. Remove it?',
      );
      expect(texts.t('sms.notification.trust_title', ['BANQUEMISR']), 'Trust messages from BANQUEMISR?');
    });

    test('a missing key is the key itself', () {
      expect(SmsNotificationTexts.fromMap(translations('en')).t('sms.nothing'), 'sms.nothing');
    });

    test('every notification string exists in both languages', () {
      final en = translations('en');
      final ar = translations('ar');
      final english = SmsNotificationTexts.fromMap(en);
      final arabic = SmsNotificationTexts.fromMap(ar, languageCode: 'ar');
      for (final key in (((en['sms'] as Map)['notification']) as Map).keys) {
        expect(english.t('sms.notification.$key'), isNot('sms.notification.$key'));
        expect(arabic.t('sms.notification.$key'), isNot('sms.notification.$key'), reason: key.toString());
      }
    });

    test('money follows the language and the digit setting', () {
      final english = SmsNotificationTexts.fromMap(translations('en'));
      expect(english.money(const Money(45000), 'EGP'), 'EGP 450');
      expect(english.money(const Money(1200050), 'EGP'), 'EGP 12,000.50');
      expect(english.money(const Money(2550), 'USD'), r'$25.50');

      final arabic = SmsNotificationTexts.fromMap(translations('ar'), languageCode: 'ar');
      expect(arabic.money(const Money(45000), 'EGP'), '٤٥٠ ج.م.');
      final western = SmsNotificationTexts.fromMap(translations('ar'), languageCode: 'ar', westernDigits: true);
      expect(western.money(const Money(45000), 'EGP'), '450 ج.م.');
      // A currency the app does not list.
      expect(english.money(const Money(2500), 'XYZ'), 'XYZ 25.00');
    });

    test('load follows the language the app saved', () async {
      SharedPreferences.setMockInitialValues({'locale': 'ar', 'western_digits': true});
      final arabic = await SmsNotificationTexts.load(await SharedPreferences.getInstance(), _FileBundle());

      expect(arabic.languageCode, 'ar');
      expect(arabic.t('sms.notification.add'), 'إضافة');
      expect(arabic.money(const Money(500), 'EGP'), '5 ج.م.');
    });

    test('load defaults to English, and reads a locale saved as ar_EG', () async {
      SharedPreferences.setMockInitialValues({});
      expect(
        (await SmsNotificationTexts.load(await SharedPreferences.getInstance(), _FileBundle())).languageCode,
        'en',
      );

      SharedPreferences.setMockInitialValues({'locale': 'ar_EG'});
      expect(
        (await SmsNotificationTexts.load(await SharedPreferences.getInstance(), _FileBundle())).languageCode,
        'ar',
      );

      SharedPreferences.setMockInitialValues({'locale': 'fr'});
      expect(
        (await SmsNotificationTexts.load(await SharedPreferences.getInstance(), _FileBundle())).languageCode,
        'en',
      );
    });
  });

  group('SmsSettingsStore', () {
    test('is off, asking, and in EGP by default', () async {
      SharedPreferences.setMockInitialValues({});
      final store = SmsSettingsStore(await SharedPreferences.getInstance());

      final settings = await store.load();

      expect(settings.enabled, isFalse);
      expect(settings.mode, SmsMode.ask);
      expect(settings.defaultWalletId, isNull);
      expect(settings.currencyCode, 'EGP');
      expect(await store.catchUpOffered(), isFalse);
    });

    test('reads the app preferences the receiver and the app share', () async {
      SharedPreferences.setMockInitialValues({
        'sms_enabled': true,
        'sms_mode': 'auto',
        'default_wallet_id': 4,
        'currency_code': 'SAR',
      });
      final store = SmsSettingsStore(await SharedPreferences.getInstance());

      final settings = await store.load();

      expect(
        (settings.enabled, settings.mode, settings.defaultWalletId, settings.currencyCode),
        (
          true,
          SmsMode.auto,
          4,
          'SAR',
        ),
      );
    });

    test('writes the switch under the key the native receiver reads', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final store = SmsSettingsStore(preferences);

      await store.setEnabled(enabled: true);
      await store.setMode(SmsMode.auto);
      await store.markCatchUpOffered();

      // shared_preferences stores it as `flutter.sms_enabled` in
      // FlutterSharedPreferences, which SmsBridge.kt reads.
      expect(preferences.getBool('sms_enabled'), isTrue);
      expect(preferences.getString('sms_mode'), 'auto');
      expect(await store.catchUpOffered(), isTrue);
      expect((await store.load()).enabled, isTrue);
      await store.setEnabled(enabled: false);
      expect((await store.load()).enabled, isFalse);
    });

    test('unknown modes fall back to asking', () {
      expect(SmsMode.parse('whatever'), SmsMode.ask);
      expect(SmsMode.parse(null), SmsMode.ask);
      expect(SmsMode.parse('auto'), SmsMode.auto);
    });
  });

  group('SmsChannel', () {
    const channel = MethodChannel(SmsChannelNames.channel);
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

    tearDown(() {
      messenger.setMockMethodCallHandler(channel, null);
    });

    test('reads the inbox through the native side', () async {
      MethodCall? received;
      messenger.setMockMethodCallHandler(channel, (call) async {
        received = call;
        return [
          {'sender': 'CIB', 'body': 'Purchase of EGP 5', 'timestamp': 1790000000000},
          {'sender': 'NBE', 'body': 'x', 'timestamp': 1790000100000},
        ];
      });
      final since = DateTime.fromMillisecondsSinceEpoch(1780000000000);

      final result = await SmsChannel().read(since: since);

      expect(received!.method, 'readInbox');
      expect((received!.arguments as Map)['sinceMillis'], 1780000000000);
      final inbox = result.getOrElse((_) => const []);
      expect(inbox.map((m) => (m.sender, m.body)), [('CIB', 'Purchase of EGP 5'), ('NBE', 'x')]);
      expect(inbox.first.receivedAt, DateTime.fromMillisecondsSinceEpoch(1790000000000));
    });

    test('an empty inbox is an empty list', () async {
      messenger.setMockMethodCallHandler(channel, (call) async => <Object?>[]);

      expect((await SmsChannel().read(since: DateTime(2026))).getOrElse((_) => throw StateError('failed')), isEmpty);
    });

    test('a permission error is a failure, not a crash', () async {
      messenger.setMockMethodCallHandler(channel, (call) async => throw PlatformException(code: 'permission'));

      expect((await SmsChannel().read(since: DateTime(2026))).isLeft(), isTrue);
    });

    test('a missing native side is a failure too', () async {
      expect((await SmsChannel().read(since: DateTime(2026))).isLeft(), isTrue);
    });

    test('listen hands each incoming message to the handler and waits for it', () async {
      final sms = SmsChannel();
      final handled = <String>[];
      sms.listen((message) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        handled.add('${message.sender}|${message.body}|${message.receivedAt.millisecondsSinceEpoch}');
      });

      await messenger.handlePlatformMessage(
        SmsChannelNames.channel,
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall(SmsChannelNames.incomingMethod, {
            'sender': 'EGBANK',
            'body': 'hello',
            'timestamp': 1790000000000,
          }),
        ),
        (reply) {},
      );

      expect(handled, ['EGBANK|hello|1790000000000']);
    });

    test('ready tells the native side the headless engine can take messages', () async {
      MethodCall? received;
      messenger.setMockMethodCallHandler(channel, (call) async {
        received = call;
        return null;
      });

      await SmsChannel().ready();

      expect(received!.method, SmsChannelNames.readyMethod);
    });
  });
}
