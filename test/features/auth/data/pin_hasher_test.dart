import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/features/auth/data/pin_hasher.dart';

String _hex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

void main() {
  group('PBKDF2-HMAC-SHA256', () {
    test('matches the published test vectors', () {
      final salt = Uint8List.fromList('salt'.codeUnits);
      expect(
        _hex(const PinHasher(iterations: 1).hash('password', salt)),
        '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b',
      );
      expect(
        _hex(const PinHasher(iterations: 4096).hash('password', salt)),
        'c5e478d59288c841aa530db6845c4c8d962893a001ce4e11a4963873aa98134a',
      );
    });

    test('hashes a PIN with a binary salt (checked against hashlib)', () {
      final salt = Uint8List.fromList(List.generate(16, (i) => i));
      expect(
        _hex(const PinHasher(iterations: 1000).hash('1234', salt)),
        '2240ea2a22754a3c4610356ef8e4d7acf25af2ac3d2d11866de97a8b7812c52c',
      );
    });
  });

  group('verification', () {
    const hasher = PinHasher(iterations: 100);

    test('accepts the right PIN and rejects any other', () {
      final salt = hasher.newSalt();
      final stored = hasher.hash('4821', salt);

      expect(hasher.matches('4821', salt, stored), isTrue);
      expect(hasher.matches('4822', salt, stored), isFalse);
      expect(hasher.matches('0000', salt, stored), isFalse);
      expect(hasher.matches('', salt, stored), isFalse);
    });

    test('the same PIN hashes differently under different salts', () {
      final a = hasher.newSalt();
      final b = hasher.newSalt();

      expect(a, hasLength(PinHasher.saltLength));
      expect(a, isNot(b));
      expect(hasher.hash('1234', a), isNot(hasher.hash('1234', b)));
    });

    test('the hash does not contain the PIN and is a full SHA-256 block', () {
      final hash = hasher.hash('1234', hasher.newSalt());

      expect(hash, hasLength(32));
      expect(_hex(hash), isNot(contains('31323334')));
    });

    test('a different cost gives a different hash', () {
      final salt = hasher.newSalt();

      expect(const PinHasher(iterations: 101).hash('1234', salt), isNot(hasher.hash('1234', salt)));
    });
  });

  group('constantTimeEquals', () {
    test('compares by value, including the length', () {
      expect(PinHasher.constantTimeEquals([1, 2, 3], [1, 2, 3]), isTrue);
      expect(PinHasher.constantTimeEquals([1, 2, 3], [1, 2, 4]), isFalse);
      expect(PinHasher.constantTimeEquals([1, 2, 3], [1, 2]), isFalse);
      expect(PinHasher.constantTimeEquals([], []), isTrue);
    });
  });
}
