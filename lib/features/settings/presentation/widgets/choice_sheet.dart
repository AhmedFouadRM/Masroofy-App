import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/settings/presentation/widgets/radio_mark.dart';
import 'package:masroofy/shared/widgets/glass_sheet.dart';

/// Figma "Bottom Sheet" with radio rows (theme, language). Resolves to the
/// tapped option, or null when dismissed.
Future<T?> showChoiceSheet<T>(
  BuildContext context, {
  required String title,
  required List<(T, String)> options,
  required T selected,
}) => showGlassSheet<T>(
  context,
  title: title,
  builder: (context) {
    final text = Theme.of(context).textTheme;
    final colors = MasroofyColors.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (value, label) in options)
          Semantics(
            inMutuallyExclusiveGroup: true,
            selected: value == selected,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label, style: text.bodyLarge!.copyWith(color: colors.textPrimary)),
              trailing: RadioMark(selected: value == selected),
              onTap: () => Navigator.pop(context, value),
            ),
          ),
      ],
    );
  },
);
