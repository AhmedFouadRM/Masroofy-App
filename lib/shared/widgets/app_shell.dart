import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/shared/widgets/glass_surface.dart';
import 'package:masroofy/shared/widgets/glowing_fab.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Tab scaffold: the tab's page with the floating glass tab bar, always
/// centred, and on the Expenses tab the add button floating above the bar's
/// trailing end (Figma "Navigation Bar" + "FAB"). The bar never moves; the
/// Scaffold scales the button in and out, and lifts it above snackbars.
class AppShell extends StatelessWidget {
  const AppShell({required this.child, super.key});

  final Widget child;

  /// Height the floating bar covers; pages pad their scroll views by this.
  static const bottomInset = 104.0;

  /// Extra room on the Expenses tab so the last row scrolls clear of the add
  /// button (56) and its gap (16).
  static const fabInset = 72.0;

  static const List<String> _tabs = [RoutePaths.expenses, RoutePaths.analytics, RoutePaths.settings];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _tabs.indexWhere(location.startsWith).clamp(0, _tabs.length - 1);

    return Scaffold(
      extendBody: true,
      body: child,
      floatingActionButton: index == 0
          ? GlowingFab(tooltip: StringManager.addExpense, onPressed: () => context.push(RoutePaths.newExpense))
          : null,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: SizedBox(
          height: _barHeight,
          child: Center(
            child: _TabBar(selected: index, onSelected: (i) => context.go(_tabs[i])),
          ),
        ),
      ),
    );
  }

  static const _barHeight = 64.0;
}

/// Figma "Navigation Bar" as an iOS 26 liquid glass tab bar: the selected
/// tab sits under a glass lens that slides (and can be dragged) between tabs.
class _TabBar extends StatelessWidget {
  const _TabBar({required this.selected, required this.onSelected});

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final label = Theme.of(context).textTheme.labelSmall!;
    GlassTab tab(IconData icon, String text) => GlassTab(
      icon: Icon(icon),
      activeIcon: Icon(icon, fill: 1),
      label: text,
      semanticLabel: text,
    );
    return SizedBox(
      width: 268,
      child: GlassTabBar.bottom(
        tabs: [
          tab(Symbols.receipt_long_rounded, StringManager.expensesTitle),
          tab(Symbols.bar_chart_rounded, StringManager.analyticsTitle),
          tab(Symbols.settings_rounded, StringManager.settingsTitle),
        ],
        selectedIndex: selected,
        onTabSelected: onSelected,
        horizontalPadding: 0,
        verticalPadding: 0,
        settings: glassSettings(context, strong: true),
        indicatorColor: colors.primarySubtle.withValues(alpha: 0.7),
        selectedIconColor: colors.textAccent,
        unselectedIconColor: colors.textSecondary,
        selectedLabelStyle: label.copyWith(color: colors.textAccent),
        unselectedLabelStyle: label.copyWith(color: colors.textSecondary),
        iconSize: 22,
      ),
    );
  }
}
