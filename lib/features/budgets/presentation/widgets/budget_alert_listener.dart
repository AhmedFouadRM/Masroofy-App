import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';
import 'package:masroofy/features/budgets/domain/usecases/take_new_budget_alerts.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/shared/categories/category_display.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The one-shot exceed alert (Budgets PRD → flow step 9). Watches budget
/// progress app-wide, so a manual save, an edit, or recurring generation
/// all trigger it the same way; several budgets crossing at once share one
/// dialog. Re-subscribes on resume, as "today" (and the window) may change.
class BudgetAlertListener extends StatefulWidget {
  const BudgetAlertListener({
    required this.budgets,
    required this.categories,
    required this.takeAlerts,
    required this.navigatorKey,
    required this.child,
    super.key,
  });

  final IBudgetRepository budgets;
  final ICategoryRepository categories;
  final TakeNewBudgetAlerts takeAlerts;

  /// The app's root navigator, which hosts the dialog.
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  @override
  State<BudgetAlertListener> createState() => _BudgetAlertListenerState();
}

class _BudgetAlertListenerState extends State<BudgetAlertListener> {
  late final AppLifecycleListener _lifecycle;
  StreamSubscription<void>? _progressSub;
  StreamSubscription<void>? _categoriesSub;
  Map<int, Category> _categories = const {};
  int? _firstWeekday;

  /// Alerts shown this session, so an in-flight marker write can't repeat one.
  final Set<(int, LocalDate)> _shown = {};
  List<BudgetProgress>? _pending;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _subscribe);
    _categoriesSub = widget.categories
        .watchAll(includeHidden: true)
        .listen((result) => result.match((_) {}, (list) => _categories = {for (final c in list) c.id: c}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final firstWeekday = context.read<SettingsCubit>().state.firstWeekday;
    if (firstWeekday == _firstWeekday) return;
    _firstWeekday = firstWeekday;
    _subscribe();
  }

  void _subscribe() {
    unawaited(_progressSub?.cancel());
    _progressSub = widget.budgets
        .watchProgress(LocalDate.today(), firstWeekday: _firstWeekday!)
        // A failed read just means no alert this time.
        .listen((result) => result.match((_) {}, _enqueue));
  }

  /// Handles snapshots one at a time, keeping only the latest waiting one.
  void _enqueue(List<BudgetProgress> snapshot) {
    _pending = snapshot;
    if (!_busy) unawaited(_drain());
  }

  Future<void> _drain() async {
    _busy = true;
    while (_pending != null) {
      final snapshot = _pending!;
      _pending = null;
      final fresh = [
        for (final progress in await widget.takeAlerts(snapshot))
          if (_shown.add((progress.budget.id, progress.periodStart))) progress,
      ];
      if (fresh.isNotEmpty && mounted) await _show(fresh);
    }
    _busy = false;
  }

  Future<void> _show(List<BudgetProgress> exceeded) async {
    final navigatorContext = widget.navigatorKey.currentContext;
    if (navigatorContext == null) return;
    await showDialog<void>(
      context: navigatorContext,
      builder: (context) {
        final colors = MasroofyColors.of(context);
        final text = Theme.of(context).textTheme;
        return AlertDialog(
          icon: Icon(Symbols.warning_rounded, color: colors.negative),
          title: Text(StringManager.budgetExceededTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(StringManager.budgetExceededBody),
              const SizedBox(height: AppSpacing.md),
              for (final progress in exceeded)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _categories[progress.budget.categoryId]?.displayName ?? '',
                          style: text.bodyLarge!.copyWith(color: colors.textPrimary),
                        ),
                      ),
                      Text(
                        StringManager.overBudget(context.money(-progress.remaining)),
                        style: text.labelLarge!.copyWith(color: colors.textNegative),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          actions: [FilledButton(onPressed: () => Navigator.pop(context), child: Text(StringManager.gotIt))],
        );
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    unawaited(_progressSub?.cancel());
    unawaited(_categoriesSub?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Re-subscribe when the region's week start changes.
    context.select<SettingsCubit, int>((cubit) => cubit.state.firstWeekday);
    return widget.child;
  }
}
