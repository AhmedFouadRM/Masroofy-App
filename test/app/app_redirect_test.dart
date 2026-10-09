import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/app/app_redirect.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/shared/auth/auth_state.dart';
import 'package:masroofy/shared/settings/settings_state.dart';

void main() {
  SettingsState settings({bool currencyChosen = true}) => SettingsState(
    themeMode: ThemeMode.system,
    currency: CurrencyUtils.defaultCurrency,
    westernDigits: false,
    firstWeekday: DateTime.saturday,
    currencyChosen: currencyChosen,
  );

  const unlocked = AuthState(isEnabled: false, isLocked: false);
  const locked = AuthState(isEnabled: true, isLocked: true);
  const enabledUnlocked = AuthState(isEnabled: true, isLocked: false);

  String? redirect(String location, {AuthState auth = unlocked, SettingsState? state}) =>
      appRedirect(auth: auth, settings: state ?? settings(), location: Uri.parse(location));

  group('first launch', () {
    test('sends every route to the currency picker until a currency is chosen', () {
      final fresh = settings(currencyChosen: false);

      expect(redirect(RoutePaths.expenses, state: fresh), RoutePaths.firstLaunch);
      expect(redirect(RoutePaths.settings, state: fresh), RoutePaths.firstLaunch);
      expect(redirect('/expenses/new', state: fresh), RoutePaths.firstLaunch);
    });

    test('stays on the picker while choosing', () {
      expect(redirect(RoutePaths.firstLaunch, state: settings(currencyChosen: false)), isNull);
    });

    test('opens the expense list once the currency is chosen', () {
      expect(redirect(RoutePaths.firstLaunch), RoutePaths.expenses);
    });

    test('does not interfere afterwards', () {
      expect(redirect(RoutePaths.expenses), isNull);
      expect(redirect(RoutePaths.settings), isNull);
    });
  });

  group('app lock', () {
    test('sends everything to the lock screen while locked, remembering where from', () {
      final to = redirect('/analytics', auth: locked)!;

      expect(Uri.parse(to).path, RoutePaths.lock);
      expect(Uri.parse(to).queryParameters['from'], '/analytics');
    });

    test('keeps the query of the original location', () {
      final to = Uri.parse(redirect('/expenses/12?x=1', auth: locked)!);

      expect(to.queryParameters['from'], '/expenses/12?x=1');
    });

    test('stays on the lock screen while locked', () {
      expect(redirect(RoutePaths.lock, auth: locked), isNull);
      expect(redirect('/lock?from=%2Fanalytics', auth: locked), isNull);
    });

    test('unlocking returns to where the user was', () {
      expect(redirect('/lock?from=%2Fanalytics', auth: enabledUnlocked), '/analytics');
      expect(redirect('/lock?from=%2Fexpenses%2F12%3Fx%3D1', auth: enabledUnlocked), '/expenses/12?x=1');
    });

    test('unlocking without a usable origin opens the expense list', () {
      expect(redirect(RoutePaths.lock, auth: enabledUnlocked), RoutePaths.expenses);
      expect(redirect('/lock?from=https%3A%2F%2Fevil.example', auth: enabledUnlocked), RoutePaths.expenses);
      expect(redirect('/lock?from=%2F%2Fevil.example', auth: enabledUnlocked), RoutePaths.expenses);
      expect(redirect('/lock?from=%2Flock', auth: enabledUnlocked), RoutePaths.expenses);
    });

    test('the lock screen is not reachable with the lock off', () {
      expect(redirect(RoutePaths.lock), RoutePaths.expenses);
    });

    test('an unlocked app with the lock on is not redirected', () {
      expect(redirect(RoutePaths.analytics, auth: enabledUnlocked), isNull);
    });

    group('an SMS notification opens the pre-filled form (SMS Import)', () {
      final target = RoutePaths.newExpenseFromSms(12);

      test('the route is /expenses/new?sms={id}', () {
        expect(target, '/expenses/new?sms=12');
        expect(Uri.parse(target).path, RoutePaths.newExpense);
        expect(Uri.parse(target).queryParameters['sms'], '12');
      });

      test('goes straight there when the app is unlocked', () {
        expect(redirect(target), isNull);
        expect(redirect(target, auth: enabledUnlocked), isNull);
      });

      test('goes to the lock screen first when App Lock is on, remembering the form', () {
        final to = Uri.parse(redirect(target, auth: locked)!);

        expect(to.path, RoutePaths.lock);
        expect(to.queryParameters['from'], target);
      });

      test('after unlocking, lands on the pre-filled form, query and all', () {
        final lock = Uri.parse(redirect(target, auth: locked)!);

        expect(redirect(lock.toString(), auth: enabledUnlocked), target);
      });

      test('a notification on first launch waits for the currency picker', () {
        expect(redirect(target, state: settings(currencyChosen: false)), RoutePaths.firstLaunch);
      });
    });

    test('a locked app shows the lock before the first-launch picker', () {
      final to = redirect(RoutePaths.expenses, auth: locked, state: settings(currencyChosen: false))!;

      expect(Uri.parse(to).path, RoutePaths.lock);
    });
  });
}
