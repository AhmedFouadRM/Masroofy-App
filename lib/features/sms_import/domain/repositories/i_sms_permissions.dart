/// Where the runtime permissions SMS Import needs stand.
enum SmsPermissionState {
  granted,

  /// Not granted; can be asked for.
  denied,

  /// Denied for good: only the system settings can change it.
  permanentlyDenied,
}

abstract interface class ISmsPermissions {
  /// Whether the SMS permissions are granted.
  Future<SmsPermissionState> sms();

  /// Asks for RECEIVE_SMS and READ_SMS. Call only after the disclosure.
  Future<SmsPermissionState> requestSms();

  /// Whether notifications may be shown (always true before Android 13).
  Future<bool> notificationsGranted();

  /// Asks for POST_NOTIFICATIONS; true when granted.
  Future<bool> requestNotifications();

  /// Opens this app's page in the system settings.
  Future<void> openSystemSettings();
}
