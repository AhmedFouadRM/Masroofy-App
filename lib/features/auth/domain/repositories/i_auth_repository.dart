import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/auth/domain/entities/lockout_record.dart';

/// App lock storage: the PIN (as a salted hash), the lock flags and the
/// failed-attempt lockout. The PIN itself is never readable back.
abstract interface class IAuthRepository {
  /// Whether App Lock is on. Read synchronously from the loaded preferences.
  bool get isEnabled;

  /// Whether the user opted into fingerprint / face unlock.
  bool get isBiometricEnabled;

  /// Turns App Lock on with a new [pin].
  Future<Either<Failure, Unit>> enable({required String pin, required bool biometric});

  /// Replaces the PIN; the lock stays on.
  Future<Either<Failure, Unit>> changePin(String pin);

  /// Turns App Lock off: deletes the PIN, the biometric opt-in and the lockout.
  Future<Either<Failure, Unit>> disable();

  /// Whether [pin] matches the stored hash (constant-time compare).
  Future<Either<Failure, bool>> verifyPin(String pin);

  Future<Either<Failure, Unit>> setBiometricEnabled({required bool enabled});

  Future<Either<Failure, LockoutRecord>> loadLockout();
  Future<Either<Failure, Unit>> saveLockout(LockoutRecord record);

  /// Whether the device has enrolled biometrics the app can use.
  Future<bool> isBiometricAvailable();

  /// Shows the system biometric prompt; `false` on cancel, failure or error.
  Future<bool> authenticateWithBiometrics(String reason);
}
