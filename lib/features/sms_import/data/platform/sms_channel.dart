import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_inbox.dart';

/// The thin Android bridge for SMS (`SmsReceiver.kt` and `SmsChannel.kt`).
/// All logic lives in Dart; the native side only delivers messages and reads
/// the inbox.
///
/// One channel serves both engines. The Android receiver calls
/// [incomingMethod] on the running app's engine if there is one, and
/// otherwise starts a headless engine and calls it there.
abstract final class SmsChannelNames {
  static const channel = 'masroofy/sms';

  /// Native to Dart: `{sender, body, timestamp}`; the result is awaited, so
  /// the receiver stays alive until the message is handled.
  static const incomingMethod = 'onSms';

  /// Dart to native, from the headless engine: its handler is ready.
  static const readyMethod = 'ready';

  /// Dart to native: `{sinceMillis}` returns the inbox as a list of maps.
  static const readInboxMethod = 'readInbox';
}

/// Receives messages from the Android receiver and reads the inbox.
class SmsChannel implements ISmsInbox {
  SmsChannel([MethodChannel? channel]) : _channel = channel ?? const MethodChannel(SmsChannelNames.channel);

  final MethodChannel _channel;

  /// Registers [handler] for messages the receiver delivers. The receiver
  /// waits for it to finish.
  void listen(Future<void> Function(RawSms sms) handler) {
    _channel.setMethodCallHandler((call) async {
      if (call.method != SmsChannelNames.incomingMethod) throw MissingPluginException();
      final arguments = Map<String, Object?>.from(call.arguments as Map);
      await handler(
        RawSms(
          sender: arguments['sender']! as String,
          body: arguments['body']! as String,
          receivedAt: DateTime.fromMillisecondsSinceEpoch(arguments['timestamp']! as int),
        ),
      );
    });
  }

  /// Tells the native side that the headless engine can take messages.
  Future<void> ready() => _channel.invokeMethod<void>(SmsChannelNames.readyMethod);

  @override
  Future<Either<Failure, List<RawSms>>> read({required DateTime since}) async {
    try {
      final rows = await _channel.invokeListMethod<Map<Object?, Object?>>(SmsChannelNames.readInboxMethod, {
        'sinceMillis': since.millisecondsSinceEpoch,
      });
      return Right([
        for (final row in rows ?? const <Map<Object?, Object?>>[])
          RawSms(
            sender: row['sender']! as String,
            body: row['body']! as String,
            receivedAt: DateTime.fromMillisecondsSinceEpoch(row['timestamp']! as int),
          ),
      ]);
    } on PlatformException catch (error, stackTrace) {
      return Left(Failure.unexpected(error: error, stackTrace: stackTrace));
    } on MissingPluginException catch (error, stackTrace) {
      return Left(Failure.unexpected(error: error, stackTrace: stackTrace));
    }
  }
}
