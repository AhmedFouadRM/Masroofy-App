import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/platform/screen_security.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';

/// Connects the app lifecycle to App Lock. `paused` starts the grace timer and
/// `resumed` re-locks after it ran out (`inactive`, e.g. a system dialog,
/// is ignored). While the lock is on it also hides the window from the app
/// switcher: `FLAG_SECURE` on Android, a cover on iOS. Expects an [AuthCubit]
/// above it, and a [Theme]: use it in `MaterialApp.builder`.
class AuthLifecycleGate extends StatefulWidget {
  const AuthLifecycleGate({required this.child, this.screenSecurity = const ScreenSecurity(), super.key});

  /// Injectable for tests.
  final ScreenSecurity screenSecurity;
  final Widget child;

  /// The iOS cover, for tests.
  @visibleForTesting
  static const ValueKey<String> privacyCoverKey = ValueKey('privacy-cover');

  @override
  State<AuthLifecycleGate> createState() => _AuthLifecycleGateState();
}

class _AuthLifecycleGateState extends State<AuthLifecycleGate> {
  late final AppLifecycleListener _lifecycle;
  AppLifecycleState _state = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onStateChange: _onStateChange);
    unawaited(widget.screenSecurity.setSecure(enabled: context.read<AuthCubit>().state.isEnabled));
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _onStateChange(AppLifecycleState state) {
    final auth = context.read<AuthCubit>();
    if (state == AppLifecycleState.paused) auth.onBackgrounded();
    if (state == AppLifecycleState.resumed) auth.onResumed();
    setState(() => _state = state);
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.isEnabled != current.isEnabled,
      listener: (context, state) => unawaited(widget.screenSecurity.setSecure(enabled: state.isEnabled)),
      child: Stack(
        children: [
          widget.child,
          // iOS has no FLAG_SECURE: cover the window as soon as it stops being
          // active, so the app switcher snapshot shows nothing.
          if (defaultTargetPlatform == TargetPlatform.iOS &&
              _state != AppLifecycleState.resumed &&
              context.select<AuthCubit, bool>((cubit) => cubit.state.isEnabled))
            Positioned.fill(
              child: ColoredBox(key: AuthLifecycleGate.privacyCoverKey, color: colors.canvas),
            ),
        ],
      ),
    );
  }
}
