import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The four dots that fill as the PIN is typed. [error] turns them red.
class PinDots extends StatelessWidget {
  const PinDots({required this.length, required this.filled, this.error = false, super.key});

  final int length;
  final int filled;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final fill = error ? colors.negative : colors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2),
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filled ? fill : Colors.transparent,
                border: Border.all(color: i < filled ? fill : colors.border, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

/// Figma "PIN pad": a 3 x 4 grid of round keys. The last row holds the
/// optional biometric key, 0 and backspace. Phone keypads don't mirror, so
/// the grid keeps its order in Arabic.
class PinKeypad extends StatelessWidget {
  const PinKeypad({
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  /// Shows the fingerprint key at the start of the last row when set.
  final VoidCallback? onBiometric;

  /// Dims the pad and ignores taps (during a lockout).
  final bool enabled;

  static const _keySize = 72.0;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: IgnorePointer(
          ignoring: !enabled,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final row in const [
                ['1', '2', '3'],
                ['4', '5', '6'],
                ['7', '8', '9'],
              ])
                _Row([for (final digit in row) _DigitKey(digit: digit, onTap: () => onDigit(digit))]),
              _Row([
                if (onBiometric == null)
                  const SizedBox.square(dimension: _keySize)
                else
                  _IconKey(
                    icon: Symbols.fingerprint_rounded,
                    label: StringManager.useBiometric,
                    color: colors.textAccent,
                    onTap: onBiometric!,
                  ),
                _DigitKey(digit: '0', onTap: () => onDigit('0')),
                _IconKey(
                  icon: Symbols.backspace_rounded,
                  label: StringManager.delete,
                  color: colors.textSecondary,
                  onTap: onBackspace,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.keys);

  final List<Widget> keys;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (i, key) in keys.indexed) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xl),
          key,
        ],
      ],
    ),
  );
}

class _DigitKey extends StatelessWidget {
  const _DigitKey({required this.digit, required this.onTap});

  final String digit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    // The glyph follows the digit setting; the pad keeps its place.
    final glyph = context.digits(digit);
    return Semantics(
      button: true,
      label: glyph,
      excludeSemantics: true,
      child: Material(
        color: colors.surfaceVariant,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: ValueKey('pin-key-$digit'),
          onTap: onTap,
          child: SizedBox.square(
            dimension: PinKeypad._keySize,
            child: Center(child: Text(glyph, style: Theme.of(context).textTheme.headlineMedium)),
          ),
        ),
      ),
    );
  }
}

class _IconKey extends StatelessWidget {
  const _IconKey({required this.icon, required this.label, required this.color, required this.onTap});

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: InkResponse(
      onTap: onTap,
      radius: PinKeypad._keySize / 2,
      child: SizedBox.square(
        dimension: PinKeypad._keySize,
        child: Icon(icon, color: color, size: 26),
      ),
    ),
  );
}
