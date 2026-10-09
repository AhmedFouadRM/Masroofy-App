import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/auth/presentation/widgets/pin_keypad.dart';
import 'package:masroofy/features/auth/presentation/widgets/pin_screen_layout.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A PIN pad that checks the PIN with [submit]; used by the lock screen and
/// the "confirm with your PIN" screens. Shows the wrong-PIN error and, while
/// the lockout delay runs, a countdown with a dimmed pad. Expects an
/// [AuthCubit] above it.
class PinCheckView extends StatefulWidget {
  const PinCheckView({
    required this.icon,
    required this.title,
    required this.message,
    required this.submit,
    this.onCorrect,
    this.onBiometric,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  /// Checks the PIN; [AuthCubit.unlockWithPin] or [AuthCubit.verifyPin].
  final Future<PinResult> Function(String pin) submit;

  /// Called after a correct PIN or a successful [onBiometric].
  final VoidCallback? onCorrect;

  /// Shows the fingerprint key when set and the user enabled biometrics.
  /// Returns whether the user passed it.
  final Future<bool> Function()? onBiometric;

  @override
  State<PinCheckView> createState() => _PinCheckViewState();
}

class _PinCheckViewState extends State<PinCheckView> {
  String _entry = '';
  PinResult? _result;
  bool _busy = false;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _syncTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Ticks once a second while a lockout delay runs, to update the countdown.
  void _syncTicker() {
    if (context.read<AuthCubit>().lockoutRemaining == null) {
      _ticker?.cancel();
      _ticker = null;
      return;
    }
    _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      _syncTicker();
    });
  }

  /// A wrong PIN stays on screen (red dots) until the next key press.
  void _clearResult() {
    if (_result != null && _result != PinResult.correct) {
      _entry = '';
      _result = null;
    }
  }

  void _onDigit(String digit) {
    if (_busy) return;
    setState(_clearResult);
    if (_entry.length >= AppConstants.pinLength) return;
    setState(() => _entry += digit);
    if (_entry.length == AppConstants.pinLength) unawaited(_submit());
  }

  void _onBackspace() {
    if (_busy) return;
    setState(() {
      _clearResult();
      if (_entry.isNotEmpty) _entry = _entry.substring(0, _entry.length - 1);
    });
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    final result = await widget.submit(_entry);
    if (!mounted) return;
    // The dots stay full: red after a failure until the next key press starts
    // over, and as they are while the screen closes after a correct PIN.
    setState(() {
      _busy = false;
      _result = result;
    });
    _syncTicker();
    if (result == PinResult.correct) widget.onCorrect?.call();
  }

  Future<void> _onBiometric() async {
    if (_busy) return;
    final passed = await widget.onBiometric!();
    if (passed && mounted) widget.onCorrect?.call();
  }

  /// `0:30`, with the digit shape of the app.
  String _countdown(BuildContext context, Duration remaining) {
    final seconds = remaining.inSeconds + (remaining.inMilliseconds % 1000 == 0 ? 0 : 1);
    final text = '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
    return context.digits(text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.lockedUntil != current.lockedUntil,
      listener: (context, state) => _syncTicker(),
      builder: (context, state) {
        final remaining = context.read<AuthCubit>().lockoutRemaining;
        final lockedOut = remaining != null;
        final failed = _result == PinResult.wrong || _result == PinResult.error;
        final (title, message, color) = switch (_result) {
          _ when lockedOut => (
            StringManager.lockedOutTitle,
            StringManager.lockedOutBody(_countdown(context, remaining)),
            colors.textWarning,
          ),
          PinResult.wrong => (widget.title, StringManager.wrongPin, colors.textNegative),
          PinResult.error => (widget.title, StringManager.failureSecureStorage, colors.textNegative),
          _ => (widget.title, widget.message, null),
        };
        return PinScreenLayout(
          icon: lockedOut ? Symbols.hourglass_top_rounded : widget.icon,
          title: title,
          message: message,
          messageColor: color,
          dots: PinDots(
            length: AppConstants.pinLength,
            filled: lockedOut ? 0 : _entry.length,
            error: failed && !lockedOut,
          ),
          keypad: PinKeypad(
            enabled: !lockedOut,
            onDigit: _onDigit,
            onBackspace: _onBackspace,
            onBiometric: widget.onBiometric != null && state.canUseBiometrics ? _onBiometric : null,
          ),
        );
      },
    );
  }
}
