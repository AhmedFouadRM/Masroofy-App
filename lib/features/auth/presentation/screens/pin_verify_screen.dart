import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/features/auth/presentation/widgets/pin_check_view.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/auth/pin_flow.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:material_symbols_icons/symbols.dart';

/// "Confirm with your PIN": a pushed screen that pops `true` once the current
/// PIN (or, to change the PIN, the fingerprint) is confirmed, `false` when
/// closed. Expects an [AuthCubit] above it.
class PinVerifyScreen extends StatelessWidget {
  const PinVerifyScreen({required this.purpose, super.key});

  final PinPurpose purpose;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>();
    final (appBarTitle, icon, message) = switch (purpose) {
      PinPurpose.changePin => (StringManager.changePin, Symbols.password_rounded, StringManager.verifyForChange),
      PinPurpose.disableLock => (StringManager.appLock, Symbols.lock_open_rounded, StringManager.verifyForDisable),
      PinPurpose.clearData => (StringManager.clearData, Symbols.delete_forever_rounded, StringManager.verifyForClear),
    };
    return AuraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            tooltip: StringManager.close,
            icon: const Icon(Symbols.close_rounded),
            onPressed: () => context.pop(false),
          ),
          title: Text(appBarTitle),
        ),
        body: SafeArea(
          child: PinCheckView(
            icon: icon,
            title: StringManager.confirmWithPin,
            message: message,
            submit: auth.verifyPin,
            onCorrect: () => context.pop(true),
            // Only changing the PIN may use the fingerprint (Auth PRD → Change PIN).
            onBiometric: purpose == PinPurpose.changePin
                ? () => auth.confirmWithBiometrics(StringManager.biometricPrompt)
                : null,
          ),
        ),
      ),
    );
  }
}
