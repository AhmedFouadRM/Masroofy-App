import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' show Left;
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/auth/presentation/cubits/pin_setup_cubit.dart';
import 'package:masroofy/features/auth/presentation/widgets/pin_keypad.dart';
import 'package:masroofy/features/auth/presentation/widgets/pin_screen_layout.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/auth/pin_flow.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/icon_dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Create a PIN, confirm it, and store it. Pops `true` when the PIN was
/// stored, `false` when closed or storing failed. Expects a [PinSetupCubit]
/// and an [AuthCubit] above it.
class PinSetupScreen extends StatelessWidget {
  const PinSetupScreen({required this.mode, super.key});

  final PinSetupMode mode;

  Future<void> _store(BuildContext context, String pin) async {
    final auth = context.read<AuthCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    var biometric = false;
    if (mode == PinSetupMode.enable && auth.state.biometricAvailable) {
      biometric = await showIconConfirmDialog(
        context,
        icon: Symbols.fingerprint_rounded,
        title: StringManager.biometricOptInTitle,
        message: StringManager.biometricOptInBody,
        confirmLabel: StringManager.turnOn,
        cancelLabel: StringManager.notNow,
      );
      if (!context.mounted) return;
    }
    final result = mode == PinSetupMode.enable
        ? await auth.enable(pin, biometric: biometric)
        : await auth.changePin(pin);
    if (result case Left(:final value)) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(StringManager.failure(value))));
    }
    router.pop(result.isRight());
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return BlocListener<PinSetupCubit, PinSetupState>(
      listenWhen: (previous, current) => previous.confirmedPin == null && current.confirmedPin != null,
      listener: (context, state) => _store(context, state.confirmedPin!),
      child: AuraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              tooltip: StringManager.close,
              icon: const Icon(Symbols.close_rounded),
              onPressed: () => context.pop(false),
            ),
            title: Text(mode == PinSetupMode.enable ? StringManager.appLock : StringManager.changePin),
          ),
          body: SafeArea(
            child: BlocBuilder<PinSetupCubit, PinSetupState>(
              builder: (context, state) {
                final cubit = context.read<PinSetupCubit>();
                final confirming = state.step == PinSetupStep.confirm;
                return PinScreenLayout(
                  icon: Symbols.password_rounded,
                  title: confirming
                      ? StringManager.confirmPin
                      : mode == PinSetupMode.enable
                      ? StringManager.createPin
                      : StringManager.createNewPin,
                  message: state.mismatch
                      ? StringManager.pinMismatch
                      : confirming
                      ? StringManager.confirmPinHint
                      : StringManager.createPinHint,
                  messageColor: state.mismatch ? colors.textNegative : null,
                  dots: PinDots(length: AppConstants.pinLength, filled: state.entry.length, error: state.mismatch),
                  note: !confirming && mode == PinSetupMode.enable ? PinNote(text: StringManager.forgotPinNote) : null,
                  keypad: PinKeypad(onDigit: cubit.addDigit, onBackspace: cubit.backspace),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
