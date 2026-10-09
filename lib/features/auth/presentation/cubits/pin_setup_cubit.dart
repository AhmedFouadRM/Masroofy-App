import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/features/auth/presentation/cubits/pin_setup_state.dart';

export 'package:masroofy/features/auth/presentation/cubits/pin_setup_state.dart';

/// Create a PIN, then confirm it. Holds only the typing state: storing the
/// PIN is the screen's job once [PinSetupState.confirmedPin] is set.
class PinSetupCubit extends Cubit<PinSetupState> {
  PinSetupCubit() : super(const PinSetupState());

  void addDigit(String digit) {
    if (state.confirmedPin != null) return;
    // A mismatch stays on screen until the next key, which starts over.
    final entry = state.mismatch ? '' : state.entry;
    if (entry.length >= AppConstants.pinLength) return;
    final typed = entry + digit;
    if (typed.length < AppConstants.pinLength) {
      emit(state.copyWith(entry: typed, mismatch: false));
      return;
    }
    switch (state.step) {
      case PinSetupStep.create:
        emit(state.copyWith(step: PinSetupStep.confirm, entry: '', firstPin: typed, mismatch: false));
      case PinSetupStep.confirm when typed == state.firstPin:
        emit(state.copyWith(entry: typed, mismatch: false, confirmedPin: typed));
      case PinSetupStep.confirm:
        emit(state.copyWith(entry: typed, mismatch: true));
    }
  }

  void backspace() {
    if (state.confirmedPin != null) return;
    if (state.mismatch) {
      emit(state.copyWith(entry: '', mismatch: false));
    } else if (state.entry.isNotEmpty) {
      emit(state.copyWith(entry: state.entry.substring(0, state.entry.length - 1)));
    }
  }
}
