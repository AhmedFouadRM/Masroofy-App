import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_colors.dart';
import 'package:masroofy/features/categories/presentation/category_icon_registry.dart';

/// The category glyph on a 16% tint of its colour (Figma "Category Avatar").
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({required this.icon, required this.color, this.size = 40, super.key});

  final String icon;
  final int color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tint = Color(color);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: tint.withValues(alpha: AppColors.categoryTintOpacity),
      ),
      child: Icon(CategoryIconRegistry.of(icon), color: tint, size: size * 0.55),
    );
  }
}
