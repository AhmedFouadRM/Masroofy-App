import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/shared/widgets/glass_surface.dart';

/// A modal bottom sheet in frosted glass (Figma "Bottom Sheet"): blur +
/// strong fill, so the page behind stays readable but never shows through
/// as sharp content.
Future<T?> showGlassSheet<T>(BuildContext context, {required WidgetBuilder builder}) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  elevation: 0,
  showDragHandle: false,
  builder: (context) => GlassSurface(
    strong: true,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
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
);
