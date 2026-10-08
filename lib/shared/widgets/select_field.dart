import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Figma "Text Field / Type=Select": looks like an input, opens a picker.
class SelectField extends StatelessWidget {
  const SelectField({
    required this.label,
    required this.value,
    required this.onTap,
    this.leading,
    this.placeholder,
    this.helperText,
    this.errorText,
    super.key,
  });

  final String label;

  /// Null shows [placeholder].
  final String? value;
  final String? placeholder;
  final Widget? leading;
  final String? helperText;
  final String? errorText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.input),
        child: InputDecorator(
          isEmpty: value == null,
          decoration: InputDecoration(
            labelText: label,
            hintText: placeholder,
            helperText: helperText,
            helperMaxLines: 2,
            errorText: errorText,
            prefixIcon: leading == null
                ? null
                : Padding(
                    padding: const EdgeInsetsDirectional.only(start: AppSpacing.md),
                    child: leading,
                  ),
            prefixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 40),
            suffixIcon: Icon(Symbols.expand_more_rounded, color: colors.textSecondary),
          ),
          child: value == null
              ? null
              : Text(value!, style: text.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
