import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/features/auth/presentation/cubits/pin_setup_cubit.dart';

void main() {
  PinSetupCubit typed(PinSetupCubit cubit, String digits) {
    digits.split('').forEach(cubit.addDigit);
    return cubit;
  }

  group('PinSetupCubit', () {
    test('four digits move from create to confirm', () {
      final cubit = typed(PinSetupCubit(), '12');
      expect(cubit.state.step, PinSetupStep.create);
      expect(cubit.state.entry, '12');

      typed(cubit, '34');

      expect(cubit.state.step, PinSetupStep.confirm);
      expect(cubit.state.entry, isEmpty);
      expect(cubit.state.firstPin, '1234');
    });

    test('a matching confirmation hands over the PIN', () {
      final cubit = typed(PinSetupCubit(), '12341234');

      expect(cubit.state.confirmedPin, '1234');
      expect(cubit.state.mismatch, isFalse);
    });

    test('a different confirmation is a mismatch and keeps the first PIN', () {
      final cubit = typed(PinSetupCubit(), '12345678');

      expect(cubit.state.mismatch, isTrue);
      expect(cubit.state.confirmedPin, isNull);
      expect(cubit.state.step, PinSetupStep.confirm);
      expect(cubit.state.firstPin, '1234');
    });

    test('the next key after a mismatch starts the confirmation over', () {
      final cubit = typed(PinSetupCubit(), '12345678')..addDigit('1');

      expect(cubit.state.mismatch, isFalse);
      expect(cubit.state.entry, '1');

      typed(cubit, '234');
      expect(cubit.state.confirmedPin, '1234');
    });

    test('backspace after a mismatch clears the entry', () {
      final cubit = typed(PinSetupCubit(), '12345678')..backspace();

      expect(cubit.state.mismatch, isFalse);
      expect(cubit.state.entry, isEmpty);
    });

    test('backspace removes one digit', () {
      final cubit = typed(PinSetupCubit(), '123')..backspace();

      expect(cubit.state.entry, '12');
    });

    test('input is ignored once the PIN is confirmed', () {
      final cubit = typed(PinSetupCubit(), '12341234')
        ..addDigit('9')
        ..backspace();

      expect(cubit.state.confirmedPin, '1234');
      expect(cubit.state.entry, '1234');
    });

    blocTest<PinSetupCubit, PinSetupState>(
      'does not emit for backspace on an empty entry',
      build: PinSetupCubit.new,
      act: (cubit) => cubit.backspace(),
      expect: () => <PinSetupState>[],
    );
  });
}
