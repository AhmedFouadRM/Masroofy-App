import 'package:local_auth/local_auth.dart';

/// Fingerprint / face unlock through `local_auth`. Never throws: any error
/// reads as "not available" or "not authenticated", and the PIN pad remains.
class LocalAuthService {
  LocalAuthService(this._auth);

  final LocalAuthentication _auth;

  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported() && (await _auth.getAvailableBiometrics()).isNotEmpty;
    } on Object {
      return false;
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      // Biometrics only: the PIN pad is the app's own fallback.
      return await _auth.authenticate(localizedReason: reason, biometricOnly: true);
    } on Object {
      return false;
    }
  }
}
