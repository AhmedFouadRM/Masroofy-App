import 'package:masroofy/app/routes.dart';
import 'package:masroofy/shared/auth/auth_state.dart';
import 'package:masroofy/shared/settings/settings_state.dart';

/// The router's redirect guard, kept apart from the router so it can be
/// tested directly. Returns the location to go to instead, or null to stay.
///
/// In order of priority:
/// 1. App Lock on and locked: everything goes to the lock screen, remembering
///    where the user was (`from`), and unlocking goes back there.
/// 2. No currency chosen yet (first launch): the currency picker.
String? appRedirect({required AuthState auth, required SettingsState settings, required Uri location}) {
  final path = location.path;

  if (auth.isEnabled && auth.isLocked) {
    if (path == RoutePaths.lock) return null;
    return Uri(path: RoutePaths.lock, queryParameters: {'from': location.toString()}).toString();
  }
  if (path == RoutePaths.lock) return _safeReturnTo(location.queryParameters['from']);

  if (!settings.currencyChosen) return path == RoutePaths.firstLaunch ? null : RoutePaths.firstLaunch;
  if (path == RoutePaths.firstLaunch) return RoutePaths.expenses;
  return null;
}

/// `from` comes from a URI, so only an in-app path is trusted.
String _safeReturnTo(String? from) {
  if (from == null || !from.startsWith('/') || from.startsWith('//')) return RoutePaths.expenses;
  final path = Uri.tryParse(from)?.path;
  if (path == null || path == RoutePaths.lock || path == RoutePaths.firstLaunch) return RoutePaths.expenses;
  return from;
}
