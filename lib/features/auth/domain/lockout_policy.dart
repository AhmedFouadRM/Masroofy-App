import 'package:masroofy/core/constants/app_constants.dart';

/// The escalating delay after consecutive wrong PINs (Auth PRD → Unlock Flow).
/// The first [AppConstants.pinAttemptsBeforeDelay] - 1 failures are free; the
/// 5th costs 30 s, then 1 min, 5 min, and 15 min for every failure after that.
abstract final class LockoutPolicy {
  static const _delays = [
    Duration(seconds: 30),
    Duration(minutes: 1),
    Duration(minutes: 5),
    Duration(minutes: 15),
  ];

  /// The delay owed after [failedAttempts] consecutive failures, or null.
  static Duration? delayFor(int failedAttempts) {
    final step = failedAttempts - AppConstants.pinAttemptsBeforeDelay;
    if (step < 0) return null;
    return _delays[step.clamp(0, _delays.length - 1)];
  }
}
