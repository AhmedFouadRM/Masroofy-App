import 'package:flutter/material.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Figma "Summary Card": the period total on an emerald card, with the
/// change against the comparison period (Analytics PRD comparison rules).
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.label,
    required this.total,
    required this.previousTotal,
    required this.comparisonLabel,
    super.key,
  });

  final String label;
  final Money total;

  /// Null while loading.
  final Money? previousTotal;
  final String comparisonLabel;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final onCard = colors.onPrimary;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final deep = Color.lerp(colors.primary, dark ? Colors.white : Colors.black, dark ? 0.12 : 0.28)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [colors.primary, deep],
        ),
        shadows: [
          BoxShadow(color: colors.primary.withValues(alpha: 0.24), blurRadius: 24, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.bodyMedium!.copyWith(color: onCard.withValues(alpha: 0.85))),
          const SizedBox(height: AppSpacing.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(context.money(total), style: text.displayMedium!.copyWith(color: onCard)),
          ),
          if (_comparison(context) case final comparison?) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              decoration: ShapeDecoration(shape: const StadiumBorder(), color: onCard.withValues(alpha: 0.14)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    total >= previousTotal! ? Symbols.trending_up_rounded : Symbols.trending_down_rounded,
                    size: 16,
                    color: onCard,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      comparison,
                      style: text.labelMedium!.copyWith(color: onCard),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// "12% (+EGP 520) vs last month"; only the amount when the previous total
  /// is 0; nothing when both are 0 or the comparison hasn't loaded.
  String? _comparison(BuildContext context) {
    final previous = previousTotal;
    if (previous == null || (previous == Money.zero && total == Money.zero)) return null;
    final change = total - previous;
    final sign = change.isNegative ? '−' : '+';
    final amount = '$sign${context.money(change.isNegative ? -change : change)}';
    if (previous == Money.zero) return '$amount $comparisonLabel';
    final percent = context.count((change.minor.abs() * 100 / previous.minor).round());
    return '$percent% ($amount) $comparisonLabel';
  }
}
