import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:masroofy/app/router.dart';
import 'package:masroofy/app/sms_background.dart';
import 'package:masroofy/app/sms_import_services.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notifier.dart';

/// Starts SMS Import's part of the running app (Android only): notification
/// taps and buttons, and messages that arrive while the app is open.
///
/// Nothing here reads SMS or asks for a permission; that waits for the user to
/// turn the feature on. Messages are handled by the same code as in the
/// headless engine ([smsBackgroundMain]), only here in the app's own isolate.
Future<void> startSmsImport(SmsImportServices services) async {
  if (!Platform.isAndroid) return;

  final handler = services.notificationHandler(
    // Both go through the router, so App Lock's redirect applies: a locked
    // app shows the lock screen first and then the page.
    onOpenReview: (importId) => unawaited(appRouter.push<void>(RoutePaths.newExpenseFromSms(importId))),
    onOpenExpense: (expenseId) => unawaited(appRouter.push<void>(RoutePaths.editExpense(expenseId))),
  );

  final plugin = services.notificationsPlugin;
  await plugin.initialize(
    settings: SmsNotifier.initializationSettings,
    onDidReceiveNotificationResponse: (response) => unawaited(_guard(() => handler.handle(response))),
    onDidReceiveBackgroundNotificationResponse: smsNotificationBackground,
  );

  // Messages that arrive while the app is running.
  services.channel.listen((sms) => _guard(() => services.processIncoming(sms)));

  // The app was opened by tapping a notification.
  final launch = await plugin.getNotificationAppLaunchDetails();
  final response = launch?.notificationResponse;
  if (launch != null && launch.didNotificationLaunchApp && response != null) {
    unawaited(_guard(() => handler.handle(response)));
  }
}

/// SMS handling must never crash the app.
Future<void> _guard(Future<void> Function() run) async {
  try {
    await run();
  } on Object catch (error, stackTrace) {
    debugPrint('SMS Import: $error\n$stackTrace');
  }
}
