import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/features/auth/presentation/widgets/pin_check_view.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The lock screen the router redirects to while the app is locked. Offers
/// the biometric prompt at once when enabled; the PIN pad is always there.
/// Unlocking flips [AuthState.isLocked], and the router redirect does the rest.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_promptBiometric());
    });
  }

  Future<bool> _promptBiometric() {
    final auth = context.read<AuthCubit>();
    return auth.unlockWithBiometrics(StringManager.biometricPrompt);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>();
    // The only way past this screen is unlocking: no back button.
    return PopScope(
      canPop: false,
      child: AuraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: PinCheckView(
              icon: Symbols.lock_rounded,
              title: StringManager.enterPin,
              message: StringManager.unlockHint,
              submit: auth.unlockWithPin,
              onBiometric: _promptBiometric,
            ),
          ),
        ),
      ),
    );
  }
}
