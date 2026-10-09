import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/shared/categories/category_chip.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/categories/category_icon_registry.dart';
import 'package:masroofy/shared/widgets/glass_sheet.dart';

/// Figma "Bottom Sheet" with the category chip grid. Resolves to the chosen
/// category id, or null when dismissed.
Future<int?> showCategoryPickerSheet(
  BuildContext context, {
  required List<Category> categories,
  required int? selectedId,
}) => showGlassSheet<int>(
  context,
  title: StringManager.chooseCategory,
  builder: (context) => SingleChildScrollView(
    child: Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final category in categories)
          CategoryChip(
            label: category.displayName,
            icon: CategoryIconRegistry.of(category.icon),
            iconColor: Color(category.color),
            selected: category.id == selectedId,
            onTap: () => Navigator.pop(context, category.id),
          ),
      ],
    ),
  ),
);
