import 'package:flutter/services.dart';

/// Hides the app window from the OS app switcher (and blocks screenshots)
/// while App Lock is on. Android only: the `masroofy/screen_security` channel
/// sets `FLAG_SECURE` in `MainActivity.kt`. iOS covers the window in
/// `AuthLifecycleGate` instead; other platforms ignore the call.
class ScreenSecurity {
  const ScreenSecurity();

  static const _channel = MethodChannel('masroofy/screen_security');

  Future<void> setSecure({required bool enabled}) async {
    try {
      await _channel.invokeMethod<void>('setSecure', {'enabled': enabled});
    } on MissingPluginException {
      // No native side on this platform.
    } on PlatformException {
      // Privacy is best-effort: never break the app over it.
    }
  }
}
