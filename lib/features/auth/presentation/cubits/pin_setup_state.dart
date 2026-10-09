import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_setup_state.freezed.dart';

enum PinSetupStep { create, confirm }

@freezed
abstract class PinSetupState with _$PinSetupState {
  const factory PinSetupState({
    @Default(PinSetupStep.create) PinSetupStep step,

    /// The digits typed on the current step.
    @Default('') String entry,

    /// The PIN from the create step, to compare the confirmation with.
    @Default('') String firstPin,

    /// The confirmation differed from the first PIN. Cleared by the next key.
    @Default(false) bool mismatch,

    /// Set once both entries match; the screen then stores the PIN.
    String? confirmedPin,
  }) = _PinSetupState;
}
