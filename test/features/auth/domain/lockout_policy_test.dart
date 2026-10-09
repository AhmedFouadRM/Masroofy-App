import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/features/auth/domain/lockout_policy.dart';

void main() {
  test('the first four wrong PINs cost nothing', () {
    for (final attempts in [0, 1, 2, 3, 4]) {
      expect(LockoutPolicy.delayFor(attempts), isNull, reason: '$attempts failures');
    }
  });

  test('delays escalate 30 s, 1 min, 5 min, 15 min from the fifth failure', () {
    expect(LockoutPolicy.delayFor(5), const Duration(seconds: 30));
    expect(LockoutPolicy.delayFor(6), const Duration(minutes: 1));
    expect(LockoutPolicy.delayFor(7), const Duration(minutes: 5));
    expect(LockoutPolicy.delayFor(8), const Duration(minutes: 15));
  });

  test('the delay is capped at 15 minutes', () {
    expect(LockoutPolicy.delayFor(9), const Duration(minutes: 15));
    expect(LockoutPolicy.delayFor(500), const Duration(minutes: 15));
  });
}
