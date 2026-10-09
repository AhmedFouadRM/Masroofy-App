import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/auth/domain/entities/lockout_record.dart';
import 'package:masroofy/features/auth/domain/lockout_policy.dart';
import 'package:masroofy/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:masroofy/shared/auth/auth_state.dart';

export 'package:masroofy/shared/auth/auth_state.dart';

/// The outcome of checking a PIN.
enum PinResult {
  correct,

  /// Wrong PIN; try again.
  wrong,

  /// Too many wrong PINs: the PIN was not checked, or this failure started a delay.
  lockedOut,

  /// The PIN could not be checked (secure storage unavailable).
  error,
}

/// App-wide lock state, provided above `MaterialApp` and read by the router
/// redirect. Owns the unlock flow, the failed-attempt lockout and the
/// 30-second grace period. [now] is injectable so tests control the clock.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._repository, {
    DateTime Function()? now,
    this._gracePeriod = const Duration(seconds: AppConstants.reLockGracePeriodSeconds),
  }) : _now = now ?? DateTime.now,
       super(
         AuthState(
           isEnabled: _repository.isEnabled,
           // A cold launch with the lock on starts locked.
           isLocked: _repository.isEnabled,
           biometricEnabled: _repository.isBiometricEnabled,
         ),
       );

  final IAuthRepository _repository;
  final DateTime Function() _now;
  final Duration _gracePeriod;

  /// When the app went to the background; null while it is in the foreground.
  DateTime? _backgroundedAt;

  /// Loads what needs async I/O: the persisted lockout and biometric support.
  /// Awaited in `main()` before the first frame, so the lock screen is right.
  Future<void> load() async {
    final available = await _repository.isBiometricAvailable();
    final lockout = (await _repository.loadLockout()).getOrElse((_) => LockoutRecord.none);
    emit(
      state.copyWith(
        biometricAvailable: available,
        failedAttempts: lockout.failedAttempts,
        lockedUntil: lockout.lockedUntil,
      ),
    );
  }

  /// Time left of the current delay, or null when PIN entry is allowed.
  Duration? get lockoutRemaining {
    final until = state.lockedUntil;
    if (until == null) return null;
    final remaining = until.difference(_now());
    return remaining > Duration.zero ? remaining : null;
  }

  /// Checks [pin] and does the lockout bookkeeping, without unlocking. Used
  /// for sensitive actions (change PIN, turn the lock off, clear data).
  Future<PinResult> verifyPin(String pin) async {
    if (lockoutRemaining != null) return PinResult.lockedOut;
    final (failed, matches) = (await _repository.verifyPin(pin)).fold((_) => (true, false), (ok) => (false, ok));
    if (failed) return PinResult.error;
    if (matches) {
      await _resetLockout();
      return PinResult.correct;
    }
    return _recordFailure();
  }

  /// Checks [pin] and, when correct, unlocks the app.
  Future<PinResult> unlockWithPin(String pin) async {
    final result = await verifyPin(pin);
    if (result == PinResult.correct) emit(state.copyWith(isLocked: false));
    return result;
  }

  /// Shows the biometric prompt without unlocking, to confirm a sensitive
  /// action. `false` when biometrics are unavailable or the user failed them.
  Future<bool> confirmWithBiometrics(String reason) async {
    if (!state.canUseBiometrics) return false;
    return _repository.authenticateWithBiometrics(reason);
  }

  /// Shows the biometric prompt and, on success, unlocks the app.
  Future<bool> unlockWithBiometrics(String reason) async {
    final confirmed = await confirmWithBiometrics(reason);
    if (confirmed) {
      // The owner proved who they are: wrong PINs before this no longer count.
      await _resetLockout();
      emit(state.copyWith(isLocked: false));
    }
    return confirmed;
  }

  /// Turns fingerprint unlock on after the user proves it works with the
  /// system prompt. `false` when biometrics are unavailable or the prompt failed.
  Future<bool> turnOnBiometrics(String reason) async {
    if (!state.biometricAvailable || !await _repository.authenticateWithBiometrics(reason)) return false;
    return (await setBiometricEnabled(enabled: true)).isRight();
  }

  /// Turns App Lock on with [pin] (already entered twice). The app stays
  /// unlocked: the user is in it.
  Future<Either<Failure, Unit>> enable(String pin, {required bool biometric}) async {
    final result = await _repository.enable(pin: pin, biometric: biometric);
    if (result.isRight()) {
      emit(
        state.copyWith(
          isEnabled: true,
          isLocked: false,
          biometricEnabled: biometric,
          failedAttempts: 0,
          lockedUntil: null,
        ),
      );
    }
    return result;
  }

  Future<Either<Failure, Unit>> changePin(String pin) async {
    final result = await _repository.changePin(pin);
    if (result.isRight()) emit(state.copyWith(failedAttempts: 0, lockedUntil: null));
    return result;
  }

  /// Turns App Lock off; the caller has already verified the PIN.
  Future<Either<Failure, Unit>> disable() async {
    final result = await _repository.disable();
    if (result.isRight()) {
      emit(
        state.copyWith(
          isEnabled: false,
          isLocked: false,
          biometricEnabled: false,
          failedAttempts: 0,
          lockedUntil: null,
        ),
      );
    }
    return result;
  }

  Future<Either<Failure, Unit>> setBiometricEnabled({required bool enabled}) async {
    final result = await _repository.setBiometricEnabled(enabled: enabled);
    if (result.isRight()) emit(state.copyWith(biometricEnabled: enabled));
    return result;
  }

  /// The app moved to the background (`paused`; `inactive` is ignored).
  void onBackgrounded() => _backgroundedAt = _now();

  /// The app is back: lock it if it was away longer than the grace period.
  void onResumed() {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    if (since == null || !state.isEnabled || state.isLocked) return;
    if (_now().difference(since) > _gracePeriod) emit(state.copyWith(isLocked: true));
  }

  Future<PinResult> _recordFailure() async {
    final failedAttempts = state.failedAttempts + 1;
    final delay = LockoutPolicy.delayFor(failedAttempts);
    final record = LockoutRecord(
      failedAttempts: failedAttempts,
      lockedUntil: delay == null ? null : _now().add(delay),
    );
    // Persist first, so killing the app can't skip the delay.
    await _repository.saveLockout(record);
    emit(state.copyWith(failedAttempts: record.failedAttempts, lockedUntil: record.lockedUntil));
    return delay == null ? PinResult.wrong : PinResult.lockedOut;
  }

  Future<void> _resetLockout() async {
    if (state.failedAttempts == 0 && state.lockedUntil == null) return;
    await _repository.saveLockout(LockoutRecord.none);
    emit(state.copyWith(failedAttempts: 0, lockedUntil: null));
  }
}
