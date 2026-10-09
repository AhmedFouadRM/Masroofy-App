import 'package:meta/meta.dart';

/// The persisted failed-PIN state, so a restart doesn't reset the delay.
@immutable
final class LockoutRecord {
  const LockoutRecord({required this.failedAttempts, this.lockedUntil});

  static const none = LockoutRecord(failedAttempts: 0);

  final int failedAttempts;

  /// When the current delay ends; null when no delay applies.
  final DateTime? lockedUntil;

  @override
  bool operator ==(Object other) =>
      other is LockoutRecord && other.failedAttempts == failedAttempts && other.lockedUntil == lockedUntil;

  @override
  int get hashCode => Object.hash(failedAttempts, lockedUntil);
}
