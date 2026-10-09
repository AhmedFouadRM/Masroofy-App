import 'dart:ui' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_payload.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_texts.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_outcome.dart';

/// Posts the local notifications of SMS Import: Add / Ignore for a transaction
/// to review, Remove / Keep for a cancelled purchase, Trust / Ignore for a new
/// sender. Texts follow the app language, not the message's.
class SmsNotifier {
  SmsNotifier(this._plugin, this._texts);

  final FlutterLocalNotificationsPlugin _plugin;
  final Future<SmsNotificationTexts> Function() _texts;

  static const transactionsChannelId = 'sms_transactions';
  static const sendersChannelId = 'sms_senders';
  static const groupKey = 'masroofy_sms_transactions';
  static const _summaryId = 3000000;
  static const _accent = Color(0xFF047857);

  /// From this many review notifications on, they are grouped under a summary.
  static const groupFrom = 3;

  /// Android settings: the small icon is a white silhouette.
  static const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@drawable/ic_stat_masroofix'),
  );

  /// Posts the notification [outcome] calls for, if any.
  Future<void> announce(SmsOutcome outcome) async {
    switch (outcome) {
      case SmsNeedsReview(:final import, :final otherCurrency):
        await showReview(import, otherCurrency: otherCurrency);
      case SmsCancellationAsk(:final import):
        await showCancellationAsk(import);
      case SmsTrustPrompt(:final import):
        await showTrustPrompt(import);
      case SmsImportCancelled(:final import):
        // The purchase is gone; so is the question about it.
        await dismiss(SmsNotificationPayload.review(import.id).notificationId);
        await dismiss(SmsNotificationPayload.cancellation(import.id).notificationId);
      case SmsIgnored() || SmsRecorded():
        break;
    }
  }

  Future<void> dismiss(int notificationId) => _plugin.cancel(id: notificationId);

  /// Removes the notifications of [importId], whatever they ask.
  Future<void> dismissImport(int importId) async {
    for (final payload in [
      SmsNotificationPayload.review(importId),
      SmsNotificationPayload.cancellation(importId),
      SmsNotificationPayload.trust(importId),
    ]) {
      await dismiss(payload.notificationId);
    }
    await _updateSummary();
  }

  Future<void> showReview(SmsImport import, {required bool otherCurrency}) async {
    final texts = await _texts();
    final amount = texts.money(import.amount, import.currency);
    final income = import.kind == TransactionKind.income;
    final merchant = import.merchant;
    final headline = merchant == null
        ? texts.t(income ? 'sms.notification.income_plain' : 'sms.notification.expense_plain', [amount])
        : texts.t(income ? 'sms.notification.income_from' : 'sms.notification.expense_at', [amount, merchant]);
    final title = otherCurrency ? texts.t('sms.notification.review_title') : headline;
    final body = otherCurrency
        ? texts.t('sms.other_currency', [headline])
        : texts.t(income ? 'sms.notification.tap_income' : 'sms.notification.tap_expense');
    final payload = SmsNotificationPayload.review(import.id);
    await _plugin.show(
      id: payload.notificationId,
      title: title,
      body: body,
      payload: payload.encode(),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          transactionsChannelId,
          texts.t('sms.notification.channel_transactions'),
          channelDescription: texts.t('sms.notification.channel_transactions_desc'),
          icon: '@drawable/ic_stat_masroofix',
          color: _accent,
          groupKey: groupKey,
          styleInformation: BigTextStyleInformation(body),
          category: AndroidNotificationCategory.status,
          actions: [
            // Add opens the app on the pre-filled form.
            AndroidNotificationAction(
              SmsNotificationActions.add,
              texts.t('sms.notification.add'),
              showsUserInterface: true,
            ),
            AndroidNotificationAction(SmsNotificationActions.ignore, texts.t('sms.notification.ignore')),
          ],
        ),
      ),
    );
    await _updateSummary();
  }

  Future<void> showCancellationAsk(SmsImport import) async {
    final texts = await _texts();
    final amount = texts.money(import.amount, import.currency);
    final merchant = import.merchant;
    final body = merchant == null
        ? texts.t('sms.notification.cancelled_body_plain', [amount])
        : texts.t('sms.notification.cancelled_body', [merchant, amount]);
    final payload = SmsNotificationPayload.cancellation(import.id);
    await _plugin.show(
      id: payload.notificationId,
      title: texts.t('sms.notification.cancelled_title'),
      body: body,
      payload: payload.encode(),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          transactionsChannelId,
          texts.t('sms.notification.channel_transactions'),
          channelDescription: texts.t('sms.notification.channel_transactions_desc'),
          icon: '@drawable/ic_stat_masroofix',
          color: _accent,
          styleInformation: BigTextStyleInformation(body),
          actions: [
            AndroidNotificationAction(SmsNotificationActions.remove, texts.t('sms.notification.remove')),
            AndroidNotificationAction(SmsNotificationActions.keep, texts.t('sms.notification.keep')),
          ],
        ),
      ),
    );
  }

  /// "Trust messages from {sender}?" about the message of [import].
  Future<void> showTrustPrompt(SmsImport import) async {
    final texts = await _texts();
    final name = SenderCatalog.displayName(import.sender);
    final payload = SmsNotificationPayload.trust(import.id);
    await _plugin.show(
      id: payload.notificationId,
      title: texts.t('sms.notification.trust_title', [name]),
      body: texts.t('sms.notification.trust_body'),
      payload: payload.encode(),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          sendersChannelId,
          texts.t('sms.notification.channel_senders'),
          channelDescription: texts.t('sms.notification.channel_senders_desc'),
          icon: '@drawable/ic_stat_masroofix',
          color: _accent,
          actions: [
            AndroidNotificationAction(SmsNotificationActions.trust, texts.t('sms.notification.trust')),
            AndroidNotificationAction(SmsNotificationActions.distrust, texts.t('sms.notification.ignore')),
          ],
        ),
      ),
    );
  }

  /// Groups the review notifications under a summary once there are
  /// [groupFrom] of them, and removes the summary when fewer are left.
  Future<void> _updateSummary() async {
    final active = await _plugin.getActiveNotifications();
    final reviews = active.where((n) => n.groupKey != null && n.groupKey!.contains(groupKey) && n.id != _summaryId);
    if (reviews.length < groupFrom) {
      if (active.any((n) => n.id == _summaryId)) await _plugin.cancel(id: _summaryId);
      return;
    }
    final texts = await _texts();
    await _plugin.show(
      id: _summaryId,
      title: texts.t('sms.notification.summary', [reviews.length.toString()]),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          transactionsChannelId,
          texts.t('sms.notification.channel_transactions'),
          channelDescription: texts.t('sms.notification.channel_transactions_desc'),
          icon: '@drawable/ic_stat_masroofix',
          color: _accent,
          groupKey: groupKey,
          setAsGroupSummary: true,
          onlyAlertOnce: true,
          styleInformation: const InboxStyleInformation(<String>[]),
        ),
      ),
    );
  }
}
