import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/shared/widgets/glass_surface.dart';

/// A modal bottom sheet in liquid glass (Figma "Bottom Sheet"): a floating
/// card inset from the screen edges, as on iOS 26.
Future<T?> showGlassSheet<T>(BuildContext context, {required WidgetBuilder builder}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  elevation: 0,
  showDragHandle: false,
  builder: (context) => SafeArea(
    minimum: const EdgeInsets.all(AppSpacing.sm),
    child: GlassSurface(
      strong: true,
      radius: AppRadius.sheet + 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Container(
              width: 36,
              height: 4,
              decoration: ShapeDecoration(shape: const StadiumBorder(), color: MasroofyColors.of(context).border),
            ),
          ),
          Flexible(child: builder(context)),
        ],
      ),
    ),
  ),
);
