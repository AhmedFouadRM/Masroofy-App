import 'package:meta/meta.dart';

/// What a notification is about, carried in its payload.
enum SmsNotificationKind {
  /// A transaction waiting for Add / Ignore.
  review,

  /// A purchase that was cancelled: Remove / Keep.
  cancellation,

  /// A sender to Trust or Ignore.
  trust,
}

/// The ids of the notification buttons.
abstract final class SmsNotificationActions {
  static const add = 'add';
  static const ignore = 'ignore';
  static const remove = 'remove';
  static const keep = 'keep';
  static const trust = 'trust';
  static const distrust = 'distrust';
}

/// The payload of an SMS notification: its [kind] and the `sms_imports` id it
/// is about, as `review:12`.
@immutable
final class SmsNotificationPayload {
  const SmsNotificationPayload(this.kind, this.importId);

  const SmsNotificationPayload.review(int importId) : this(SmsNotificationKind.review, importId);
  const SmsNotificationPayload.cancellation(int importId) : this(SmsNotificationKind.cancellation, importId);
  const SmsNotificationPayload.trust(int importId) : this(SmsNotificationKind.trust, importId);

  final SmsNotificationKind kind;
  final int importId;

  String encode() => '${kind.name}:$importId';

  /// Null when [payload] is not one of ours.
  static SmsNotificationPayload? tryParse(String? payload) {
    if (payload == null) return null;
    final parts = payload.split(':');
    if (parts.length != 2) return null;
    final kind = SmsNotificationKind.values.asNameMap()[parts[0]];
    final id = int.tryParse(parts[1]);
    return kind == null || id == null ? null : SmsNotificationPayload(kind, id);
  }

  /// A review notification keeps the import's id; the others are offset so
  /// the three never collide.
  int get notificationId => switch (kind) {
    SmsNotificationKind.review => importId,
    SmsNotificationKind.cancellation => 1000000 + importId,
    SmsNotificationKind.trust => 2000000 + importId,
  };

  @override
  bool operator ==(Object other) => other is SmsNotificationPayload && other.kind == kind && other.importId == importId;

  @override
  int get hashCode => Object.hash(kind, importId);
}
