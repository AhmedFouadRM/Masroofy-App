import 'package:flutter/material.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';

/// Figma "Section Header": a title with an optional trailing value.
class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.trailing, super.key});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(AppSpacing.xs, AppSpacing.xl, AppSpacing.xs, AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(title, style: text.titleMedium)),
          if (trailing != null)
            Text(trailing!, style: text.labelLarge!.copyWith(color: MasroofyColors.of(context).textSecondary)),
        ],
      ),
    );
  }
}

/// Rows on one card, separated by inset dividers.
class GroupedCard extends StatelessWidget {
  const GroupedCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (index, child) in children.indexed) ...[
            if (index > 0) const Divider(indent: 72),
            child,
          ],
        ],
      ),
    );
  }
}
