import 'package:meta/meta.dart';

/// What happens to a transaction found in an SMS.
enum SmsMode {
  /// A notification asks first (the default).
  ask,

  /// Saved to the default wallet with no notification.
  auto;

  static SmsMode parse(String? name) => values.asNameMap()[name] ?? ask;
}

/// The settings SMS Import reads for every message.
@immutable
final class SmsSettings {
  const SmsSettings({
    required this.enabled,
    required this.mode,
    required this.defaultWalletId,
    required this.currencyCode,
  });

  final bool enabled;
  final SmsMode mode;

  /// Where an automatic import goes; null until the app has chosen one.
  final int? defaultWalletId;

  /// The app currency; an SMS in another one is never recorded automatically.
  final String currencyCode;
}
