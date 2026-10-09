import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/settings/presentation/widgets/radio_mark.dart';
import 'package:masroofy/shared/widgets/glass_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Figma "Bottom Sheet" with radio rows (theme, language). Resolves to the
/// tapped option, or null when dismissed.
Future<T?> showChoiceSheet<T>(
  BuildContext context, {
  required String title,
  required List<(T, String)> options,
  required T selected,
}) => showGlassSheet<T>(
  context,
  builder: (context) {
    final text = Theme.of(context).textTheme;
    final colors = MasroofyColors.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: text.titleLarge)),
                IconButton(
                  icon: const Icon(Symbols.close_rounded),
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            for (final (value, label) in options)
              Semantics(
                inMutuallyExclusiveGroup: true,
                selected: value == selected,
                child: ListTile(
                  title: Text(label, style: text.bodyLarge!.copyWith(color: colors.textPrimary)),
                  trailing: RadioMark(selected: value == selected),
                  onTap: () => Navigator.pop(context, value),
                ),
              ),
          ],
        ),
      ),
    );
  },
);
