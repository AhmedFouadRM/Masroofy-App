import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show Left, Right, unit;
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/auth/domain/entities/lockout_record.dart';
import 'package:masroofy/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:masroofy/features/auth/presentation/cubits/pin_setup_cubit.dart';
import 'package:masroofy/features/auth/presentation/screens/lock_screen.dart';
import 'package:masroofy/features/auth/presentation/screens/pin_setup_screen.dart';
import 'package:masroofy/features/auth/presentation/screens/pin_verify_screen.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/auth/pin_flow.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/router_host.dart';

class _MockRepository extends Mock implements IAuthRepository {}

class _MockAuth extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  setUpAll(() => registerFallbackValue(LockoutRecord.none));

  late _MockRepository repository;
  late DateTime now;

  setUp(() {
    now = DateTime.utc(2026, 10, 9, 12);
    repository = _MockRepository();
    when(() => repository.isEnabled).thenReturn(true);
    when(() => repository.isBiometricEnabled).thenReturn(false);
    when(() => repository.saveLockout(any())).thenAnswer((_) async => const Right(unit));
    when(() => repository.loadLockout()).thenAnswer((_) async => const Right(LockoutRecord.none));
    when(() => repository.isBiometricAvailable()).thenAnswer((_) async => false);
    when(() => repository.verifyPin(any())).thenAnswer(
      (invocation) async => Right(invocation.positionalArguments.single == '1234'),
    );
  });

  Future<void> typePin(WidgetTester tester, String pin, {bool warnIfMissed = true}) async {
    for (final digit in pin.split('')) {
      await tester.tap(find.byKey(ValueKey('pin-key-$digit')), warnIfMissed: warnIfMissed);
      await tester.pump();
    }
    await tester.pump();
  }

  Future<AuthCubit> pumpLock(WidgetTester tester, {Locale locale = const Locale('en'), bool biometric = false}) async {
    if (biometric) {
      when(() => repository.isBiometricEnabled).thenReturn(true);
      when(() => repository.isBiometricAvailable()).thenAnswer((_) async => true);
      when(() => repository.authenticateWithBiometrics(any())).thenAnswer((_) async => false);
    }
    final auth = AuthCubit(repository, now: () => now);
    addTearDown(auth.close);
    await auth.load();
    await pumpApp(
      tester,
      const LockScreen(),
      locale: locale,
      providers: [BlocProvider<AuthCubit>.value(value: auth)],
    );
    return auth;
  }

  group('LockScreen', () {
    testWidgets('shows the PIN pad with empty dots', (tester) async {
      await pumpLock(tester);

      expect(find.text('Enter PIN'), findsOneWidget);
      expect(find.text('Enter your PIN to open Masroofix.'), findsOneWidget);
      for (final digit in '0123456789'.split('')) {
        expect(find.byKey(ValueKey('pin-key-$digit')), findsOneWidget);
      }
      expect(find.byTooltip('Use fingerprint'), findsNothing);
    });

    testWidgets('the right PIN unlocks', (tester) async {
      final auth = await pumpLock(tester);

      await typePin(tester, '1234');

      expect(auth.state.isLocked, isFalse);
    });

    testWidgets('a wrong PIN shows the error and stays locked; the next key starts over', (tester) async {
      final auth = await pumpLock(tester);

      await typePin(tester, '0000');
      expect(find.text('Incorrect PIN. Try again.'), findsOneWidget);
      expect(auth.state.isLocked, isTrue);

      await typePin(tester, '1');
      expect(find.text('Incorrect PIN. Try again.'), findsNothing);
      expect(find.text('Enter your PIN to open Masroofix.'), findsOneWidget);
    });

    testWidgets('after 5 wrong PINs: a countdown, a dimmed pad, then back to normal', (tester) async {
      final auth = await pumpLock(tester);

      for (var i = 0; i < 5; i++) {
        await typePin(tester, '0000');
      }

      expect(find.text('Too many tries'), findsOneWidget);
      expect(find.text('Try again in 0:30. Your data is safe.'), findsOneWidget);
      expect(find.text('Enter PIN'), findsNothing);
      expect(
        tester
            .widget<Opacity>(
              find.ancestor(of: find.byKey(const ValueKey('pin-key-5')), matching: find.byType(Opacity)).first,
            )
            .opacity,
        0.4,
      );

      // The pad is dead: even the right PIN is not accepted.
      await typePin(tester, '1234', warnIfMissed: false);
      expect(auth.state.isLocked, isTrue);
      verify(() => repository.verifyPin(any())).called(5);

      now = now.add(const Duration(seconds: 12));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Try again in 0:18. Your data is safe.'), findsOneWidget);

      now = now.add(const Duration(seconds: 20));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Enter PIN'), findsOneWidget);
      expect(find.text('Too many tries'), findsNothing);

      await typePin(tester, '1234');
      expect(auth.state.isLocked, isFalse);
    });

    testWidgets('a lockout saved before a restart is still counting down', (tester) async {
      when(() => repository.loadLockout()).thenAnswer(
        (_) async => Right(LockoutRecord(failedAttempts: 6, lockedUntil: now.add(const Duration(seconds: 59)))),
      );

      await pumpLock(tester);

      expect(find.text('Try again in 0:59. Your data is safe.'), findsOneWidget);
    });

    testWidgets('a long delay is shown as minutes and seconds', (tester) async {
      when(() => repository.loadLockout()).thenAnswer(
        (_) async => Right(LockoutRecord(failedAttempts: 8, lockedUntil: now.add(const Duration(minutes: 15)))),
      );

      await pumpLock(tester);

      expect(find.text('Try again in 15:00. Your data is safe.'), findsOneWidget);
    });

    testWidgets('the fingerprint key appears when enabled, and unlocking is tried at once', (tester) async {
      final auth = await pumpLock(tester, biometric: true);
      await tester.pump();

      expect(find.byTooltip('Use fingerprint'), findsNothing); // a Semantics label, not a tooltip
      expect(find.bySemanticsLabel('Use fingerprint'), findsOneWidget);
      verify(() => repository.authenticateWithBiometrics('Authenticate to unlock')).called(1);
      expect(auth.state.isLocked, isTrue);
    });

    testWidgets('a successful fingerprint unlocks without a PIN', (tester) async {
      when(() => repository.isBiometricEnabled).thenReturn(true);
      when(() => repository.isBiometricAvailable()).thenAnswer((_) async => true);
      when(() => repository.authenticateWithBiometrics(any())).thenAnswer((_) async => true);
      final auth = AuthCubit(repository, now: () => now);
      addTearDown(auth.close);
      await auth.load();
      await pumpApp(tester, const LockScreen(), providers: [BlocProvider<AuthCubit>.value(value: auth)]);
      await tester.pump();

      expect(auth.state.isLocked, isFalse);
    });

    testWidgets('Arabic: translated, with Eastern digits on the keys', (tester) async {
      await pumpLock(tester, locale: const Locale('ar'));

      expect(find.text('أدخل الرمز السري'), findsOneWidget);
      expect(find.text('أدخل الرمز السري لفتح مصروفكس.'), findsOneWidget);
      expect(find.text('٥'), findsOneWidget);
      expect(find.text('5'), findsNothing);

      await typePin(tester, '0000');
      expect(find.text('رمز خاطئ. حاول مرة أخرى.'), findsOneWidget);
    });

    testWidgets('Arabic countdown uses Eastern digits', (tester) async {
      when(() => repository.loadLockout()).thenAnswer(
        (_) async => Right(LockoutRecord(failedAttempts: 5, lockedUntil: now.add(const Duration(seconds: 30)))),
      );

      await pumpLock(tester, locale: const Locale('ar'));

      expect(find.text('محاولات كثيرة جدًا'), findsOneWidget);
      expect(find.text('حاول مرة أخرى بعد ٠:٣٠. بياناتك في أمان.'), findsOneWidget);
    });
  });

  group('PinVerifyScreen', () {
    Future<List<bool?>> pumpVerify(WidgetTester tester, PinPurpose purpose, AuthCubit auth) async {
      final results = <bool?>[];
      await pumpApp(
        tester,
        RouterHost(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: TextButton(
                  onPressed: () async => results.add(await context.push<bool>('/verify', extra: purpose)),
                  child: const Text('open'),
                ),
              ),
            ),
            GoRoute(
              path: '/verify',
              builder: (context, state) => PinVerifyScreen(purpose: state.extra! as PinPurpose),
            ),
          ],
        ),
        providers: [BlocProvider<AuthCubit>.value(value: auth)],
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      return results;
    }

    late AuthCubit auth;

    setUp(() {
      auth = AuthCubit(repository, now: () => now);
      addTearDown(auth.close);
    });

    testWidgets('the right PIN pops true, without unlocking anything', (tester) async {
      final results = await pumpVerify(tester, PinPurpose.clearData, auth);
      expect(find.text('Clear all data'), findsOneWidget);
      expect(find.text('Confirm with your PIN'), findsOneWidget);
      expect(find.text('Enter your PIN to delete all data.'), findsOneWidget);

      await typePin(tester, '1234');
      await tester.pumpAndSettle();

      expect(results, [true]);
    });

    testWidgets('a wrong PIN stays and shows the error', (tester) async {
      final results = await pumpVerify(tester, PinPurpose.disableLock, auth);
      expect(find.text('Enter your PIN to turn off App lock.'), findsOneWidget);

      await typePin(tester, '9999');

      expect(find.text('Incorrect PIN. Try again.'), findsOneWidget);
      expect(results, isEmpty);
    });

    testWidgets('closing pops false', (tester) async {
      final results = await pumpVerify(tester, PinPurpose.changePin, auth);
      expect(find.text('Change PIN'), findsOneWidget);
      expect(find.text('Enter your current PIN to set a new one.'), findsOneWidget);

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(results, [false]);
    });

    testWidgets('only changing the PIN may use the fingerprint', (tester) async {
      when(() => repository.isBiometricEnabled).thenReturn(true);
      when(() => repository.isBiometricAvailable()).thenAnswer((_) async => true);
      when(() => repository.authenticateWithBiometrics(any())).thenAnswer((_) async => true);
      auth = AuthCubit(repository, now: () => now);
      addTearDown(auth.close);
      await auth.load();

      final results = await pumpVerify(tester, PinPurpose.clearData, auth);
      expect(find.bySemanticsLabel('Use fingerprint'), findsNothing);
      expect(results, isEmpty);
    });

    testWidgets('a fingerprint confirms a PIN change', (tester) async {
      when(() => repository.isBiometricEnabled).thenReturn(true);
      when(() => repository.isBiometricAvailable()).thenAnswer((_) async => true);
      when(() => repository.authenticateWithBiometrics(any())).thenAnswer((_) async => true);
      auth = AuthCubit(repository, now: () => now);
      addTearDown(auth.close);
      await auth.load();

      final results = await pumpVerify(tester, PinPurpose.changePin, auth);
      await tester.tap(find.bySemanticsLabel('Use fingerprint'));
      await tester.pumpAndSettle();

      expect(results, [true]);
      expect(auth.state.isLocked, isTrue, reason: 'confirming an action is not unlocking');
    });
  });

  group('PinSetupScreen', () {
    late _MockAuth auth;
    late List<bool?> results;

    setUp(() {
      auth = _MockAuth();
      results = [];
      when(() => auth.enable(any(), biometric: any(named: 'biometric'))).thenAnswer((_) async => const Right(unit));
      when(() => auth.changePin(any())).thenAnswer((_) async => const Right(unit));
    });

    Future<void> pumpSetup(
      WidgetTester tester,
      PinSetupMode mode, {
      bool biometricAvailable = false,
      Locale locale = const Locale('en'),
    }) async {
      whenListen(
        auth,
        const Stream<AuthState>.empty(),
        initialState: AuthState(
          isEnabled: mode == PinSetupMode.change,
          isLocked: false,
          biometricAvailable: biometricAvailable,
        ),
      );
      await pumpApp(
        tester,
        RouterHost(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: TextButton(
                  onPressed: () async => results.add(await context.push<bool>('/set')),
                  child: const Text('open'),
                ),
              ),
            ),
            GoRoute(
              path: '/set',
              builder: (context, state) => BlocProvider(
                create: (_) => PinSetupCubit(),
                child: PinSetupScreen(mode: mode),
              ),
            ),
          ],
        ),
        locale: locale,
        providers: [BlocProvider<AuthCubit>.value(value: auth)],
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('create step: 4 digits, the forgotten-PIN note', (tester) async {
      await pumpSetup(tester, PinSetupMode.enable);

      expect(find.text('App lock'), findsOneWidget);
      expect(find.text('Create a PIN'), findsOneWidget);
      expect(find.text("4 digits. You'll enter it each time you open Masroofix."), findsOneWidget);
      expect(
        find.text(
          'Forgot it? Without fingerprint unlock, the only way back in is reinstalling, which deletes all your data.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('a mismatch shows the error on the confirm step', (tester) async {
      await pumpSetup(tester, PinSetupMode.enable);

      await typePin(tester, '1234');
      expect(find.text('Enter it again'), findsOneWidget);
      expect(find.text('Create a PIN'), findsNothing);
      await typePin(tester, '1235');

      expect(find.text("PINs don't match. Try again."), findsOneWidget);
      verifyNever(() => auth.enable(any(), biometric: any(named: 'biometric')));
    });

    testWidgets('matching PINs enable the lock and close the screen', (tester) async {
      await pumpSetup(tester, PinSetupMode.enable);

      await typePin(tester, '12341234');
      await tester.pumpAndSettle();

      verify(() => auth.enable('1234', biometric: false)).called(1);
      expect(results, [true]);
    });

    testWidgets('with biometrics on the device: asks, and Turn on opts in', (tester) async {
      await pumpSetup(tester, PinSetupMode.enable, biometricAvailable: true);

      await typePin(tester, '12341234');
      await tester.pumpAndSettle();
      expect(find.text('Unlock with fingerprint?'), findsOneWidget);
      verifyNever(() => auth.enable(any(), biometric: any(named: 'biometric')));

      await tester.tap(find.text('Turn on'));
      await tester.pumpAndSettle();

      verify(() => auth.enable('1234', biometric: true)).called(1);
      expect(results, [true]);
    });

    testWidgets('Not now keeps the PIN only', (tester) async {
      await pumpSetup(tester, PinSetupMode.enable, biometricAvailable: true);

      await typePin(tester, '12341234');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();

      verify(() => auth.enable('1234', biometric: false)).called(1);
    });

    testWidgets('a failure to store is shown and closes with false', (tester) async {
      when(() => auth.enable(any(), biometric: any(named: 'biometric'))).thenAnswer(
        (_) async => const Left(Failure.secureStorage(message: 'x')),
      );
      await pumpSetup(tester, PinSetupMode.enable);

      await typePin(tester, '12341234');
      await tester.pumpAndSettle();

      expect(results, [false]);
      expect(find.text("Couldn't access secure storage on this device"), findsOneWidget);
    });

    testWidgets('closing without finishing pops false and stores nothing', (tester) async {
      await pumpSetup(tester, PinSetupMode.enable);
      await typePin(tester, '12');

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(results, [false]);
      verifyNever(() => auth.enable(any(), biometric: any(named: 'biometric')));
    });

    testWidgets('changing the PIN: no forgotten-PIN note, no fingerprint offer', (tester) async {
      await pumpSetup(tester, PinSetupMode.change, biometricAvailable: true);

      expect(find.text('Change PIN'), findsOneWidget);
      expect(find.text('Create a new PIN'), findsOneWidget);
      expect(find.textContaining('Forgot it?'), findsNothing);

      await typePin(tester, '56785678');
      await tester.pumpAndSettle();

      verify(() => auth.changePin('5678')).called(1);
      verifyNever(() => auth.enable(any(), biometric: any(named: 'biometric')));
      expect(results, [true]);
    });

    testWidgets('Arabic', (tester) async {
      await pumpSetup(tester, PinSetupMode.enable, locale: const Locale('ar'));

      expect(find.text('أنشئ رمزًا سريًا'), findsOneWidget);
      await typePin(tester, '1234');
      expect(find.text('أدخله مرة أخرى'), findsOneWidget);
      await typePin(tester, '0000');
      expect(find.text('الرمزان غير متطابقين. حاول مرة أخرى.'), findsOneWidget);
    });
  });
}
