import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/shared/widgets/glass_surface.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Tab scaffold: the tab's page with the floating glass tab bar and, on the
/// Expenses tab, the add button beside it (Figma "Navigation Bar" + "FAB").
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  /// Height the floating bar covers; pages pad their scroll views by this.
  static const bottomInset = 104.0;

  static const List<String> _tabs = [RoutePaths.expenses, RoutePaths.analytics, RoutePaths.settings];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere(location.startsWith).clamp(0, _tabs.length - 1);

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Row(
          children: [
            _TabBar(selected: index, onSelected: (i) => context.go(_tabs[i])),
            const Spacer(),
            if (index == 0) _AddButton(onPressed: () => context.push(RoutePaths.newExpense)),
          ],
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Symbols.receipt_long_rounded, StringManager.expensesTitle),
      (Symbols.bar_chart_rounded, StringManager.analyticsTitle),
      (Symbols.settings_rounded, StringManager.settingsTitle),
    ];
    return GlassSurface(
      strong: true,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (i, (icon, label)) in items.indexed)
              _Tab(icon: icon, label: label, selected: i == selected, onTap: () => onSelected(i)),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final color = selected ? colors.textAccent : colors.textSecondary;
    return Semantics(
      selected: selected,
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: selected ? colors.primarySubtle : Colors.transparent,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 80,
            height: 52,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 22, fill: selected ? 1 : 0),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: colors.primary.withValues(alpha: 0.32), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: FloatingActionButton(
        heroTag: null,
        tooltip: StringManager.addExpense,
        onPressed: onPressed,
        child: const Icon(Symbols.add_rounded),
      ),
    );
  }
}
