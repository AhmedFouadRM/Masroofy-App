import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:masroofy/features/auth/domain/entities/lockout_record.dart';

/// The Keystore / Keychain-backed values of the lock (Auth PRD → Storage).
/// Throws storage errors; the repository maps them to failures.
class PinSecureDatasource {
  PinSecureDatasource(this._storage);

  final FlutterSecureStorage _storage;

  static const _hashKey = 'pin_hash';
  static const _saltKey = 'pin_salt';
  static const _failedAttemptsKey = 'failed_attempts';
  static const _lockedUntilKey = 'locked_until';

  Future<({Uint8List hash, Uint8List salt})?> readPin() async {
    final hash = await _storage.read(key: _hashKey);
    final salt = await _storage.read(key: _saltKey);
    if (hash == null || salt == null) return null;
    return (hash: base64Decode(hash), salt: base64Decode(salt));
  }

  Future<void> writePin({required Uint8List hash, required Uint8List salt}) async {
    await _storage.write(key: _hashKey, value: base64Encode(hash));
    await _storage.write(key: _saltKey, value: base64Encode(salt));
  }

  Future<LockoutRecord> readLockout() async {
    final attempts = int.tryParse(await _storage.read(key: _failedAttemptsKey) ?? '') ?? 0;
    final until = DateTime.tryParse(await _storage.read(key: _lockedUntilKey) ?? '');
    return LockoutRecord(failedAttempts: attempts, lockedUntil: until);
  }

  Future<void> writeLockout(LockoutRecord record) async {
    await _storage.write(key: _failedAttemptsKey, value: '${record.failedAttempts}');
    if (record.lockedUntil case final until?) {
      await _storage.write(key: _lockedUntilKey, value: until.toUtc().toIso8601String());
    } else {
      await _storage.delete(key: _lockedUntilKey);
    }
  }

  /// Removes the PIN and the lockout.
  Future<void> deleteAll() async {
    for (final key in [_hashKey, _saltKey, _failedAttemptsKey, _lockedUntilKey]) {
      await _storage.delete(key: key);
    }
  }
}
