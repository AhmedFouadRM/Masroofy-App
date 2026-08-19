import 'package:masroofy/features/auth/domain/repositories/i_auth_repository.dart';

class LocalAuthService implements IAuthRepository {
  // TODO: Inject local_auth and flutter_secure_storage

  @override
  Future<bool> isEnabled() async {
    // TODO: implement
    return false;
  }

  @override
  Future<bool> isLocked() async {
    // TODO: implement
    return false;
  }

  @override
  Future<bool> verifyPin(String pin) async {
    // TODO: implement
    return false;
  }

  @override
  Future<void> setPin(String pin) async {
    // TODO: implement
  }

  @override
  Future<void> clearPin() async {
    // TODO: implement
  }

  @override
  Future<bool> checkBiometrics() async {
    // TODO: implement
    return false;
  }
}
