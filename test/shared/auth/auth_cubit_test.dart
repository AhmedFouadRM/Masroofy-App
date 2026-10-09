import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/auth/domain/entities/lockout_record.dart';
import 'package:masroofy/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuth extends Mock implements IAuthRepository {}

void main() {
  setUpAll(() => registerFallbackValue(LockoutRecord.none));

  late _MockAuth repository;
  late DateTime now;
  var lockEnabled = true;
  var biometricEnabled = false;

  /// A cubit on a controllable clock; `enabled` is what the repository says at start.
  AuthCubit build({bool enabled = true, bool biometric = false}) {
    lockEnabled = enabled;
    biometricEnabled = biometric;
    final cubit = AuthCubit(repository, now: () => now);
    addTearDown(cubit.close);
    return cubit;
  }

  void pinIs(String pin) => when(
    () => repository.verifyPin(any()),
  ).thenAnswer((invocation) async => Right(invocation.positionalArguments.single == pin));

  setUp(() {
    now = DateTime.utc(2026, 10, 9, 12);
    repository = _MockAuth();
    when(() => repository.isEnabled).thenAnswer((_) => lockEnabled);
    when(() => repository.isBiometricEnabled).thenAnswer((_) => biometricEnabled);
    when(() => repository.saveLockout(any())).thenAnswer((_) async => const Right(unit));
    when(() => repository.loadLockout()).thenAnswer((_) async => const Right(LockoutRecord.none));
    when(() => repository.isBiometricAvailable()).thenAnswer((_) async => false);
    pinIs('1234');
  });

  group('starting state', () {
    test('a cold launch with the lock on starts locked', () {
      final cubit = build();
      expect(cubit.state.isEnabled, isTrue);
      expect(cubit.state.isLocked, isTrue);
    });

    test('with the lock off nothing is locked', () {
      final cubit = build(enabled: false);
      expect(cubit.state.isEnabled, isFalse);
      expect(cubit.state.isLocked, isFalse);
    });

    test('load() restores the persisted lockout and biometric support', () async {
      final until = now.add(const Duration(minutes: 5));
      when(
        () => repository.loadLockout(),
      ).thenAnswer((_) async => Right(LockoutRecord(failedAttempts: 7, lockedUntil: until)));
      when(() => repository.isBiometricAvailable()).thenAnswer((_) async => true);
      final cubit = build(biometric: true);

      await cubit.load();

      expect(cubit.state.failedAttempts, 7);
      expect(cubit.state.lockedUntil, until);
      expect(cubit.lockoutRemaining, const Duration(minutes: 5));
      expect(cubit.state.canUseBiometrics, isTrue);
    });

    test('a lockout that already ran out leaves PIN entry open', () async {
      when(() => repository.loadLockout()).thenAnswer(
        (_) async => Right(LockoutRecord(failedAttempts: 5, lockedUntil: now.subtract(const Duration(seconds: 1)))),
      );
      final cubit = build();
      await cubit.load();

      expect(cubit.lockoutRemaining, isNull);
      expect(await cubit.unlockWithPin('1234'), PinResult.correct);
    });

    test('an unreadable lockout does not stop the app from opening', () async {
      when(() => repository.loadLockout()).thenAnswer((_) async => const Left(Failure.secureStorage(message: 'x')));
      final cubit = build();
      await cubit.load();

      expect(cubit.state.failedAttempts, 0);
      expect(cubit.state.lockedUntil, isNull);
    });
  });

  group('PIN', () {
    test('the right PIN unlocks', () async {
      final cubit = build();

      expect(await cubit.unlockWithPin('1234'), PinResult.correct);
      expect(cubit.state.isLocked, isFalse);
    });

    test('a wrong PIN stays locked and counts', () async {
      final cubit = build();

      expect(await cubit.unlockWithPin('0000'), PinResult.wrong);
      expect(cubit.state.isLocked, isTrue);
      expect(cubit.state.failedAttempts, 1);
      expect(cubit.state.lockedUntil, isNull);
    });

    test('a failure that can be persisted is, so a restart cannot skip the delay', () async {
      final cubit = build();
      for (var i = 0; i < 5; i++) {
        await cubit.unlockWithPin('0000');
      }

      verify(
        () =>
            repository.saveLockout(LockoutRecord(failedAttempts: 5, lockedUntil: now.add(const Duration(seconds: 30)))),
      ).called(1);
    });

    test('the fifth wrong PIN starts a 30 second delay that blocks further tries', () async {
      final cubit = build();
      for (var i = 0; i < 4; i++) {
        expect(await cubit.unlockWithPin('0000'), PinResult.wrong);
      }

      expect(await cubit.unlockWithPin('0000'), PinResult.lockedOut);
      expect(cubit.lockoutRemaining, const Duration(seconds: 30));

      // Even the right PIN is not checked during the delay.
      clearInteractions(repository);
      expect(await cubit.unlockWithPin('1234'), PinResult.lockedOut);
      expect(cubit.state.isLocked, isTrue);
      verifyNever(() => repository.verifyPin(any()));
    });

    test('the delay counts down with the clock, then tries are allowed again', () async {
      final cubit = build();
      for (var i = 0; i < 5; i++) {
        await cubit.unlockWithPin('0000');
      }

      now = now.add(const Duration(seconds: 12));
      expect(cubit.lockoutRemaining, const Duration(seconds: 18));
      now = now.add(const Duration(seconds: 18));
      expect(cubit.lockoutRemaining, isNull);
      expect(await cubit.unlockWithPin('1234'), PinResult.correct);
    });

    test('delays escalate: 30 s, 1 min, 5 min, then 15 min', () async {
      final cubit = build();
      final expected = [
        const Duration(seconds: 30),
        const Duration(minutes: 1),
        const Duration(minutes: 5),
        const Duration(minutes: 15),
        const Duration(minutes: 15),
      ];
      for (var i = 0; i < 4; i++) {
        await cubit.unlockWithPin('0000');
      }
      for (final delay in expected) {
        await cubit.unlockWithPin('0000');
        expect(cubit.lockoutRemaining, delay);
        now = now.add(delay);
      }
    });

    test('a correct PIN resets the count', () async {
      final cubit = build();
      for (var i = 0; i < 3; i++) {
        await cubit.unlockWithPin('0000');
      }

      await cubit.unlockWithPin('1234');

      expect(cubit.state.failedAttempts, 0);
      verify(() => repository.saveLockout(LockoutRecord.none)).called(1);
    });

    test('verifyPin checks without unlocking (sensitive actions)', () async {
      final cubit = build();

      expect(await cubit.verifyPin('1234'), PinResult.correct);
      expect(cubit.state.isLocked, isTrue);
    });

    test('an unreadable PIN store is an error, not a wrong PIN', () async {
      when(() => repository.verifyPin(any())).thenAnswer((_) async => const Left(Failure.secureStorage(message: 'x')));
      final cubit = build();

      expect(await cubit.unlockWithPin('1234'), PinResult.error);
      expect(cubit.state.failedAttempts, 0);
      expect(cubit.state.isLocked, isTrue);
    });
  });

  group('biometrics', () {
    setUp(() => when(() => repository.isBiometricAvailable()).thenAnswer((_) async => true));

    test('unlock when the prompt succeeds', () async {
      when(() => repository.authenticateWithBiometrics(any())).thenAnswer((_) async => true);
      final cubit = build(biometric: true);
      await cubit.load();

      expect(await cubit.unlockWithBiometrics('Unlock'), isTrue);
      expect(cubit.state.isLocked, isFalse);
    });

    test('stay locked when it fails', () async {
      when(() => repository.authenticateWithBiometrics(any())).thenAnswer((_) async => false);
      final cubit = build(biometric: true);
      await cubit.load();

      expect(await cubit.unlockWithBiometrics('Unlock'), isFalse);
      expect(cubit.state.isLocked, isTrue);
    });

    test('are not offered unless the user opted in', () async {
      final cubit = build();
      await cubit.load();

      expect(await cubit.unlockWithBiometrics('Unlock'), isFalse);
      verifyNever(() => repository.authenticateWithBiometrics(any()));
    });

    test('confirmWithBiometrics approves an action without unlocking', () async {
      when(() => repository.authenticateWithBiometrics(any())).thenAnswer((_) async => true);
      final cubit = build(biometric: true);
      await cubit.load();

      expect(await cubit.confirmWithBiometrics('Confirm'), isTrue);
      expect(cubit.state.isLocked, isTrue);
    });

    test('turning them on needs the prompt to pass', () async {
      when(
        () => repository.setBiometricEnabled(enabled: any(named: 'enabled')),
      ).thenAnswer((_) async => const Right(unit));
      when(() => repository.authenticateWithBiometrics(any())).thenAnswer((_) async => false);
      final cubit = build();
      await cubit.load();

      expect(await cubit.turnOnBiometrics('Confirm'), isFalse);
      expect(cubit.state.biometricEnabled, isFalse);

      when(() => repository.authenticateWithBiometrics(any())).thenAnswer((_) async => true);
      expect(await cubit.turnOnBiometrics('Confirm'), isTrue);
      expect(cubit.state.biometricEnabled, isTrue);
    });
  });

  group('enable, change and disable', () {
    test('enable turns the lock on without locking the user out of the app', () async {
      when(
        () => repository.enable(
          pin: any(named: 'pin'),
          biometric: any(named: 'biometric'),
        ),
      ).thenAnswer((_) async => const Right(unit));
      final cubit = build(enabled: false);

      expect((await cubit.enable('4821', biometric: true)).isRight(), isTrue);

      expect(cubit.state.isEnabled, isTrue);
      expect(cubit.state.isLocked, isFalse);
      expect(cubit.state.biometricEnabled, isTrue);
      verify(() => repository.enable(pin: '4821', biometric: true)).called(1);
    });

    test('a failed enable changes nothing', () async {
      when(
        () => repository.enable(
          pin: any(named: 'pin'),
          biometric: any(named: 'biometric'),
        ),
      ).thenAnswer((_) async => const Left(Failure.secureStorage(message: 'x')));
      final cubit = build(enabled: false);

      expect((await cubit.enable('4821', biometric: false)).isLeft(), isTrue);
      expect(cubit.state.isEnabled, isFalse);
    });

    test('changePin keeps the lock and clears the failure count', () async {
      when(() => repository.changePin(any())).thenAnswer((_) async => const Right(unit));
      final cubit = build();
      await cubit.unlockWithPin('0000');

      await cubit.changePin('9999');

      expect(cubit.state.isEnabled, isTrue);
      expect(cubit.state.failedAttempts, 0);
      verify(() => repository.changePin('9999')).called(1);
    });

    test('disable turns everything off', () async {
      when(() => repository.disable()).thenAnswer((_) async => const Right(unit));
      final cubit = build(biometric: true);

      await cubit.disable();

      expect(cubit.state.isEnabled, isFalse);
      expect(cubit.state.isLocked, isFalse);
      expect(cubit.state.biometricEnabled, isFalse);
    });
  });

  group('grace period', () {
    AuthCubit unlocked() {
      final cubit = build();
      cubit.emit(cubit.state.copyWith(isLocked: false));
      return cubit;
    }

    test('returning within 30 seconds does not lock', () {
      final cubit = unlocked()..onBackgrounded();
      now = now.add(const Duration(seconds: 30));
      cubit.onResumed();

      expect(cubit.state.isLocked, isFalse);
    });

    test('returning after more than 30 seconds locks', () {
      final cubit = unlocked()..onBackgrounded();
      now = now.add(const Duration(seconds: 31));
      cubit.onResumed();

      expect(cubit.state.isLocked, isTrue);
    });

    test('a resume without a pause (a system dialog) never locks', () {
      final cubit = unlocked();
      now = now.add(const Duration(hours: 1));
      cubit.onResumed();

      expect(cubit.state.isLocked, isFalse);
    });

    test('each pause starts a fresh timer', () {
      final cubit = unlocked()..onBackgrounded();
      now = now.add(const Duration(seconds: 20));
      cubit
        ..onResumed()
        ..onBackgrounded();
      now = now.add(const Duration(seconds: 20));
      cubit.onResumed();

      expect(cubit.state.isLocked, isFalse);
    });

    test('with the lock off nothing ever locks', () {
      final cubit = build(enabled: false)..onBackgrounded();
      now = now.add(const Duration(hours: 1));
      cubit.onResumed();

      expect(cubit.state.isLocked, isFalse);
    });

    test('the grace period is configurable', () {
      lockEnabled = true;
      final cubit = AuthCubit(repository, now: () => now, gracePeriod: const Duration(seconds: 5));
      addTearDown(cubit.close);
      cubit
        ..emit(cubit.state.copyWith(isLocked: false))
        ..onBackgrounded();
      now = now.add(const Duration(seconds: 6));
      cubit.onResumed();

      expect(cubit.state.isLocked, isTrue);
    });
  });
}
