import 'package:masroofy/features/sms_import/domain/repositories/i_sms_permissions.dart';
import 'package:permission_handler/permission_handler.dart';

/// [ISmsPermissions] over `permission_handler`. Request only after the
/// disclosure screen (Google Play's prominent disclosure).
class SmsPermissionService implements ISmsPermissions {
  const SmsPermissionService();

  @override
  Future<SmsPermissionState> sms() async => _state(await Permission.sms.status);

  @override
  Future<SmsPermissionState> requestSms() async => _state(await Permission.sms.request());

  @override
  Future<bool> notificationsGranted() async => (await Permission.notification.status).isGranted;

  @override
  Future<bool> requestNotifications() async => (await Permission.notification.request()).isGranted;

  @override
  Future<void> openSystemSettings() async {
    await openAppSettings();
  }

  static SmsPermissionState _state(PermissionStatus status) => switch (status) {
    PermissionStatus.granted || PermissionStatus.limited => SmsPermissionState.granted,
    PermissionStatus.permanentlyDenied || PermissionStatus.restricted => SmsPermissionState.permanentlyDenied,
    PermissionStatus.denied || PermissionStatus.provisional => SmsPermissionState.denied,
  };
}
