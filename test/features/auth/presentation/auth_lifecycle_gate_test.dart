import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show Right, unit;
import 'package:masroofy/core/platform/screen_security.dart';
import 'package:masroofy/features/auth/domain/entities/lockout_record.dart';
import 'package:masroofy/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:masroofy/features/auth/presentation/widgets/auth_lifecycle_gate.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class _MockRepository extends Mock implements IAuthRepository {}

class _RecordingSecurity extends ScreenSecurity {
  _RecordingSecurity(this.calls);

  final List<bool> calls;

  @override
  Future<void> setSecure({required bool enabled}) async => calls.add(enabled);
}

void main() {
  late _MockRepository repository;
  late DateTime now;
  late List<bool> secureCalls;

  setUp(() {
    now = DateTime.utc(2026, 10, 9, 12);
    secureCalls = [];
    repository = _MockRepository();
    when(() => repository.isEnabled).thenReturn(true);
    when(() => repository.isBiometricEnabled).thenReturn(false);
    when(() => repository.disable()).thenAnswer((_) async => const Right(unit));
    when(() => repository.saveLockout(any())).thenAnswer((_) async => const Right(unit));
    when(() => repository.verifyPin(any())).thenAnswer((_) async => const Right(true));
  });

  setUpAll(() => registerFallbackValue(LockoutRecord.none));

  Future<AuthCubit> pumpGate(WidgetTester tester) async {
    final auth = AuthCubit(repository, now: () => now);
    addTearDown(auth.close);
    await auth.unlockWithPin('1234');
    await pumpApp(
      tester,
      AuthLifecycleGate(
        screenSecurity: _RecordingSecurity(secureCalls),
        child: const Scaffold(body: Text('app')),
      ),
      providers: [BlocProvider<AuthCubit>.value(value: auth)],
    );
    return auth;
  }

  void lifecycle(WidgetTester tester, AppLifecycleState state) => tester.binding.handleAppLifecycleStateChanged(state);

  group('grace period', () {
    testWidgets('a quick trip to the background does not lock', (tester) async {
      final auth = await pumpGate(tester);

      lifecycle(tester, AppLifecycleState.inactive);
      lifecycle(tester, AppLifecycleState.hidden);
      lifecycle(tester, AppLifecycleState.paused);
      now = now.add(const Duration(seconds: 29));
      lifecycle(tester, AppLifecycleState.hidden);
      lifecycle(tester, AppLifecycleState.inactive);
      lifecycle(tester, AppLifecycleState.resumed);

      expect(auth.state.isLocked, isFalse);
    });

    testWidgets('more than 30 seconds away locks', (tester) async {
      final auth = await pumpGate(tester);

      lifecycle(tester, AppLifecycleState.inactive);
      lifecycle(tester, AppLifecycleState.hidden);
      lifecycle(tester, AppLifecycleState.paused);
      now = now.add(const Duration(seconds: 31));
      lifecycle(tester, AppLifecycleState.hidden);
      lifecycle(tester, AppLifecycleState.inactive);
      lifecycle(tester, AppLifecycleState.resumed);

      expect(auth.state.isLocked, isTrue);
    });

    testWidgets('a system dialog (inactive only) never starts the timer', (tester) async {
      final auth = await pumpGate(tester);

      lifecycle(tester, AppLifecycleState.inactive);
      now = now.add(const Duration(minutes: 10));
      lifecycle(tester, AppLifecycleState.resumed);

      expect(auth.state.isLocked, isFalse);
    });
  });

  group('app switcher privacy', () {
    testWidgets('FLAG_SECURE follows the lock: set at start, and when it is turned off', (tester) async {
      final auth = await pumpGate(tester);
      expect(secureCalls, [true]);

      await auth.disable();
      await tester.pump();

      expect(secureCalls, [true, false]);
    });

    testWidgets('is not set while the lock is off', (tester) async {
      when(() => repository.isEnabled).thenReturn(false);
      await pumpGate(tester);

      expect(secureCalls, [false]);
    });

    testWidgets('iOS: the window is covered whenever the app is not active', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await pumpGate(tester);
        final cover = find.byKey(AuthLifecycleGate.privacyCoverKey);

        expect(cover, findsNothing);

        lifecycle(tester, AppLifecycleState.inactive);
        await tester.pump();
        expect(cover, findsOneWidget);

        lifecycle(tester, AppLifecycleState.resumed);
        await tester.pump();
        expect(cover, findsNothing);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });

    testWidgets('Android relies on FLAG_SECURE, with no cover', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      try {
        await pumpGate(tester);

        lifecycle(tester, AppLifecycleState.inactive);
        await tester.pump();

        expect(find.byKey(AuthLifecycleGate.privacyCoverKey), findsNothing);
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  });

  group('ScreenSecurity', () {
    testWidgets('calls the native channel', (tester) async {
      final calls = <MethodCall>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(const MethodChannel('masroofy/screen_security'), (
        call,
      ) async {
        calls.add(call);
        return null;
      });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('masroofy/screen_security'),
          null,
        ),
      );

      await const ScreenSecurity().setSecure(enabled: true);

      expect(calls.single.method, 'setSecure');
      expect(calls.single.arguments, {'enabled': true});
    });

    testWidgets('is silent where there is no native side, and when the platform call fails', (tester) async {
      const channel = MethodChannel('masroofy/screen_security');
      final messenger = tester.binding.defaultBinaryMessenger;
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

      messenger.setMockMethodCallHandler(channel, (call) async => throw MissingPluginException());
      await const ScreenSecurity().setSecure(enabled: true);

      messenger.setMockMethodCallHandler(channel, (call) async => throw PlatformException(code: 'boom'));
      await const ScreenSecurity().setSecure(enabled: false);
    });
  });
}
