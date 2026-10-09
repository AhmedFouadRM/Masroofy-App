import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// App-lock state, held in memory above `MaterialApp` (Auth PRD → Engineering).
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    /// App Lock is on (a PIN is set).
    required bool isEnabled,

    /// The lock screen must be shown. Starts true on a cold launch with the lock on.
    required bool isLocked,

    /// The user opted into fingerprint / face unlock.
    @Default(false) bool biometricEnabled,

    /// The device has enrolled biometrics.
    @Default(false) bool biometricAvailable,

    /// Consecutive wrong PINs; persisted so a restart doesn't reset it.
    @Default(0) int failedAttempts,

    /// The current delay ends at this time, if one applies.
    DateTime? lockedUntil,
  }) = _AuthState;

  const AuthState._();

  /// Whether the lock screen may offer the biometric key.
  bool get canUseBiometrics => biometricEnabled && biometricAvailable;
}
