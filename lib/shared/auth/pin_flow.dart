/// Why the PIN is asked for; picks the texts and whether biometrics may stand in.
enum PinPurpose { changePin, disableLock, clearData }

/// What the Set PIN screen sets the PIN for.
enum PinSetupMode {
  /// Turning App Lock on: create, confirm, then offer the fingerprint.
  enable,

  /// Replacing the PIN after the current one was confirmed.
  change,
}
