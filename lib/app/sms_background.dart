import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masroofy/app/sms_import_services.dart';
import 'package:masroofy/features/sms_import/data/platform/sms_channel.dart';

/// Dart entry point of the headless engine that Android's SMS receiver starts
/// when a message arrives and the app is not running
/// (`SmsReceiver.kt`, `SmsBridge.kt`). It opens the same database as the app,
/// handles the message, posts its notification, and tells the receiver it is
/// done. It never builds a widget.
@pragma('vm:entry-point')
Future<void> smsBackgroundMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final channel = SmsChannel()
    ..listen((sms) async {
      final services = await SmsImportServices.open();
      try {
        await services.processIncoming(sms);
      } finally {
        await services.dispose();
      }
    });
  await channel.ready();
}

/// Runs in a background isolate when the user taps a notification button that
/// does not open the app (Ignore, Remove, Keep, Trust). Must stay a
/// top-level function with this annotation.
@pragma('vm:entry-point')
Future<void> smsNotificationBackground(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final services = await SmsImportServices.open();
  try {
    await services.notificationHandler().handle(response);
  } finally {
    await services.dispose();
  }
}
