abstract class IAuthRepository {
  Future<bool> isEnabled();
  Future<bool> isLocked();
  Future<bool> verifyPin(String pin);
  Future<void> setPin(String pin);
  Future<void> clearPin();
  Future<bool> checkBiometrics();
}
