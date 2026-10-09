import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:local_auth/local_auth.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/auth/data/datasources/pin_secure_datasource.dart';
import 'package:masroofy/features/auth/data/pin_hasher.dart';
import 'package:masroofy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:masroofy/features/auth/data/services/local_auth_service.dart';
import 'package:masroofy/features/auth/domain/entities/lockout_record.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockLocalAuthentication extends Mock implements LocalAuthentication {}

void main() {
  late SharedPreferences preferences;
  late FlutterSecureStorage storage;
  late _MockLocalAuthentication localAuth;
  late AuthRepositoryImpl repository;

  Future<void> build([Map<String, Object> prefs = const {}, Map<String, String> secure = const {}]) async {
    SharedPreferences.setMockInitialValues(prefs);
    FlutterSecureStorage.setMockInitialValues({...secure});
    preferences = await SharedPreferences.getInstance();
    storage = const FlutterSecureStorage();
    localAuth = _MockLocalAuthentication();
    repository = AuthRepositoryImpl(
      preferences: preferences,
      secure: PinSecureDatasource(storage),
      hasher: const PinHasher(iterations: 50),
      biometrics: LocalAuthService(localAuth),
    );
  }

  T right<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));

  setUp(build);

  test('is off, with no PIN, on a fresh install', () async {
    expect(repository.isEnabled, isFalse);
    expect(repository.isBiometricEnabled, isFalse);
    expect(right(await repository.verifyPin('1234')), isFalse);
  });

  group('enable', () {
    test('stores a salted hash, never the PIN, and turns the lock on', () async {
      right(await repository.enable(pin: '4821', biometric: true));

      expect(repository.isEnabled, isTrue);
      expect(repository.isBiometricEnabled, isTrue);
      final all = await storage.readAll();
      expect(all.keys, containsAll(['pin_hash', 'pin_salt']));
      expect(all.values, everyElement(isNot(contains('4821'))));
      expect(right(await repository.verifyPin('4821')), isTrue);
      expect(right(await repository.verifyPin('4822')), isFalse);
    });

    test('uses a fresh salt each time, so equal PINs store different hashes', () async {
      right(await repository.enable(pin: '1111', biometric: false));
      final first = (await storage.readAll())['pin_hash'];
      right(await repository.changePin('1111'));

      expect((await storage.readAll())['pin_hash'], isNot(first));
      expect(right(await repository.verifyPin('1111')), isTrue);
    });

    test('also clears an old lockout', () async {
      right(await repository.saveLockout(LockoutRecord(failedAttempts: 6, lockedUntil: DateTime.utc(2030))));
      right(await repository.enable(pin: '1234', biometric: false));

      expect(right(await repository.loadLockout()), LockoutRecord.none);
    });
  });

  test('changePin replaces the PIN and keeps the lock on', () async {
    right(await repository.enable(pin: '1234', biometric: false));
    right(await repository.changePin('9876'));

    expect(repository.isEnabled, isTrue);
    expect(right(await repository.verifyPin('1234')), isFalse);
    expect(right(await repository.verifyPin('9876')), isTrue);
  });

  test('disable removes the PIN, the flags and the lockout', () async {
    right(await repository.enable(pin: '1234', biometric: true));
    right(await repository.saveLockout(LockoutRecord(failedAttempts: 5, lockedUntil: DateTime.utc(2030))));
    right(await repository.disable());

    expect(repository.isEnabled, isFalse);
    expect(repository.isBiometricEnabled, isFalse);
    expect(await storage.readAll(), isEmpty);
    expect(right(await repository.verifyPin('1234')), isFalse);
  });

  test('the biometric opt-in can change on its own', () async {
    right(await repository.enable(pin: '1234', biometric: false));
    right(await repository.setBiometricEnabled(enabled: true));
    expect(repository.isBiometricEnabled, isTrue);
    right(await repository.setBiometricEnabled(enabled: false));
    expect(repository.isBiometricEnabled, isFalse);
  });

  group('lockout persistence', () {
    test('survives a restart: a new repository reads what the last one saved', () async {
      final until = DateTime.utc(2026, 10, 9, 12);
      right(await repository.saveLockout(LockoutRecord(failedAttempts: 7, lockedUntil: until)));

      final reopened = AuthRepositoryImpl(
        preferences: preferences,
        secure: PinSecureDatasource(const FlutterSecureStorage()),
        hasher: const PinHasher(iterations: 50),
        biometrics: LocalAuthService(localAuth),
      );
      final record = right(await reopened.loadLockout());

      expect(record.failedAttempts, 7);
      expect(record.lockedUntil, until);
    });

    test('a cleared delay reads back as none', () async {
      right(await repository.saveLockout(LockoutRecord(failedAttempts: 5, lockedUntil: DateTime.utc(2030))));
      right(await repository.saveLockout(const LockoutRecord(failedAttempts: 5)));

      expect(right(await repository.loadLockout()).lockedUntil, isNull);
    });
  });

  group('biometrics', () {
    test('available only with a supported device and enrolled biometrics', () async {
      when(() => localAuth.isDeviceSupported()).thenAnswer((_) async => true);
      when(() => localAuth.getAvailableBiometrics()).thenAnswer((_) async => [BiometricType.fingerprint]);
      expect(await repository.isBiometricAvailable(), isTrue);

      when(() => localAuth.getAvailableBiometrics()).thenAnswer((_) async => []);
      expect(await repository.isBiometricAvailable(), isFalse);

      when(() => localAuth.isDeviceSupported()).thenAnswer((_) async => false);
      expect(await repository.isBiometricAvailable(), isFalse);
    });

    test('plugin errors read as unavailable / not authenticated, never thrown', () async {
      when(() => localAuth.isDeviceSupported()).thenThrow(Exception('boom'));
      expect(await repository.isBiometricAvailable(), isFalse);

      when(
        () => localAuth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).thenThrow(Exception('boom'));
      expect(await repository.authenticateWithBiometrics('Unlock'), isFalse);
    });

    test('authenticates with biometrics only', () async {
      when(
        () => localAuth.authenticate(
          localizedReason: any(named: 'localizedReason'),
          biometricOnly: any(named: 'biometricOnly'),
        ),
      ).thenAnswer((_) async => true);

      expect(await repository.authenticateWithBiometrics('Unlock'), isTrue);
      verify(() => localAuth.authenticate(localizedReason: 'Unlock', biometricOnly: true)).called(1);
    });
  });
}
