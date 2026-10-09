import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// PBKDF2-HMAC-SHA256 for the 4-digit PIN (Auth PRD → Enable Auth).
///
/// A 4-digit PIN has only 10,000 values, so the hash cannot stop an attacker
/// who has the stored hash; it only keeps the PIN from being read back. The
/// real protection is the secure storage and the escalating lockout.
///
/// Runs on the calling isolate (about half a second at the default cost on a
/// phone), which is acceptable for a button press.
class PinHasher {
  const PinHasher({this.iterations = 100000});

  final int iterations;

  static const saltLength = 16;

  /// One SHA-256 block, so PBKDF2 needs a single block (T1).
  static const _hashLength = 32;

  /// A fresh random per-install salt.
  Uint8List newSalt() {
    final random = Random.secure();
    return Uint8List.fromList(List.generate(saltLength, (_) => random.nextInt(256)));
  }

  /// PBKDF2 (RFC 8018) with HMAC-SHA256, deriving 32 bytes.
  Uint8List hash(String pin, Uint8List salt) {
    final hmac = Hmac(sha256, utf8.encode(pin));
    // U1 = HMAC(pin, salt || INT_32_BE(1)); T = U1 ^ U2 ^ ... ^ Uc.
    var block = Uint8List.fromList(hmac.convert([...salt, 0, 0, 0, 1]).bytes);
    final result = Uint8List.fromList(block);
    for (var i = 1; i < iterations; i++) {
      block = Uint8List.fromList(hmac.convert(block).bytes);
      for (var j = 0; j < _hashLength; j++) {
        result[j] ^= block[j];
      }
    }
    return result;
  }

  /// Whether [pin] hashes to [expected], in constant time.
  bool matches(String pin, Uint8List salt, Uint8List expected) => constantTimeEquals(hash(pin, salt), expected);

  /// Compares every byte, so the time taken doesn't reveal where they differ.
  static bool constantTimeEquals(List<int> a, List<int> b) {
    var difference = a.length ^ b.length;
    for (var i = 0; i < a.length && i < b.length; i++) {
      difference |= a[i] ^ b[i];
    }
    return difference == 0;
  }
}
