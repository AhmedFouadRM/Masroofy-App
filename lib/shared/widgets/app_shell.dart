import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
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

    final showAdd = index == 0;

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: SizedBox(
          height: _barHeight,
          child: Stack(
            children: [
              // With the add button the bar sits at the start (iOS 26 tab bar +
              // action); without it, the bar glides to the centre.
              AnimatedAlign(
                alignment: showAdd ? AlignmentDirectional.centerStart : AlignmentDirectional.center,
                duration: _motion,
                curve: Curves.easeOutCubic,
                child: _TabBar(selected: index, onSelected: (i) => context.go(_tabs[i])),
              ),
              PositionedDirectional(
                end: 0,
                top: 0,
                bottom: 0,
                child: IgnorePointer(
                  ignoring: !showAdd,
                  child: AnimatedScale(
                    scale: showAdd ? 1 : 0.6,
                    duration: _motion,
                    curve: showAdd ? Curves.easeOutBack : Curves.easeInCubic,
                    child: AnimatedOpacity(
                      opacity: showAdd ? 1 : 0,
                      duration: _motion,
                      curve: Curves.easeOut,
                      child: ExcludeSemantics(
                        excluding: !showAdd,
                        child: _AddButton(onPressed: () => context.push(RoutePaths.newExpense)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The glass tab bar's height; the add button matches it.
  static const _barHeight = 64.0;
  static const _motion = Duration(milliseconds: 380);
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

/// The emerald add button, a circle as tall as the tab bar, with its glow.
class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Tooltip(
      message: StringManager.addExpense,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: colors.primary.withValues(alpha: 0.32), blurRadius: 24, offset: const Offset(0, 10)),
          ],
        ),
        child: Material(
          color: colors.primary,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: SizedBox.square(
              dimension: AppShell._barHeight,
              child: Icon(Symbols.add_rounded, size: 28, color: colors.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
