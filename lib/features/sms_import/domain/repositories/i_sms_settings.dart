import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';

/// The preferences SMS Import runs on. Reads see what another isolate wrote.
abstract interface class ISmsSettings {
  Future<SmsSettings> load();

  Future<void> setEnabled({required bool enabled});

  Future<void> setMode(SmsMode mode);

  /// Whether the one-time "Import the last 30 days?" sheet was shown.
  Future<bool> catchUpOffered();

  Future<void> markCatchUpOffered();
}
