import 'dart:isolate';

import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/auth/data/datasources/pin_secure_datasource.dart';
import 'package:masroofy/features/auth/data/pin_hasher.dart';
import 'package:masroofy/features/auth/data/services/local_auth_service.dart';
import 'package:masroofy/features/auth/domain/entities/lockout_record.dart';
import 'package:masroofy/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart' show PreferenceKeys;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl implements IAuthRepository {
  AuthRepositoryImpl({
    required this._preferences,
    required this._secure,
    required this._hasher,
    required this._biometrics,
  });

  final SharedPreferences _preferences;
  final PinSecureDatasource _secure;
  final PinHasher _hasher;
  final LocalAuthService _biometrics;

  @override
  bool get isEnabled => _preferences.getBool(PreferenceKeys.authEnabled) ?? false;

  @override
  bool get isBiometricEnabled => _preferences.getBool(PreferenceKeys.biometricEnabled) ?? false;

  /// Keystore / Keychain errors become [SecureStorageFailure]s.
  static Future<Either<Failure, T>> _guard<T>(Future<T> Function() run) async {
    try {
      return Right(await run());
    } on Object catch (error) {
      return Left(Failure.secureStorage(message: '$error'));
    }
  }

  Future<void> _storePin(String pin) async {
    final salt = _hasher.newSalt();
    final hasher = _hasher;
    // PBKDF2 takes a moment; off the UI isolate so the keypad doesn't freeze.
    final hash = await Isolate.run(() => hasher.hash(pin, salt));
    await _secure.writePin(hash: hash, salt: salt);
  }

  @override
  Future<Either<Failure, Unit>> enable({required String pin, required bool biometric}) => _guard(() async {
    await _storePin(pin);
    await _secure.writeLockout(LockoutRecord.none);
    await _preferences.setBool(PreferenceKeys.biometricEnabled, biometric);
    // Last: the lock only counts once its PIN is safely stored.
    await _preferences.setBool(PreferenceKeys.authEnabled, true);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> changePin(String pin) => _guard(() async {
    await _storePin(pin);
    await _secure.writeLockout(LockoutRecord.none);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> disable() => _guard(() async {
    await _preferences.setBool(PreferenceKeys.authEnabled, false);
    await _preferences.setBool(PreferenceKeys.biometricEnabled, false);
    await _secure.deleteAll();
    return unit;
  });

  @override
  Future<Either<Failure, bool>> verifyPin(String pin) => _guard(() async {
    final stored = await _secure.readPin();
    if (stored == null) return false;
    final hasher = _hasher;
    return Isolate.run(() => hasher.matches(pin, stored.salt, stored.hash));
  });

  @override
  Future<Either<Failure, Unit>> setBiometricEnabled({required bool enabled}) => _guard(() async {
    await _preferences.setBool(PreferenceKeys.biometricEnabled, enabled);
    return unit;
  });

  @override
  Future<Either<Failure, LockoutRecord>> loadLockout() => _guard(_secure.readLockout);

  @override
  Future<Either<Failure, Unit>> saveLockout(LockoutRecord record) => _guard(() async {
    await _secure.writeLockout(record);
    return unit;
  });

  @override
  Future<bool> isBiometricAvailable() => _biometrics.isAvailable();

  @override
  Future<bool> authenticateWithBiometrics(String reason) => _biometrics.authenticate(reason);
}
