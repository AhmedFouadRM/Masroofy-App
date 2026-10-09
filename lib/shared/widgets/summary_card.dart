import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Figma "Summary Card": the period total on an emerald card, with the
/// change against the comparison period (Analytics PRD comparison rules), or
/// as the balance card (Income PRD): a signed [total] with [details] (In and
/// Out) below it.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    required this.label,
    required this.total,
    this.previousTotal,
    this.comparisonLabel = '',
    this.details = const [],
    this.signed = false,
    super.key,
  });

  final String label;
  final Money total;

  /// Null while loading, and for a card without a comparison.
  final Money? previousTotal;
  final String comparisonLabel;

  /// Labelled amounts under the total (the balance card's In and Out).
  final List<({String label, Money amount})> details;

  /// A balance: a negative [total] shows with a minus sign in `text/negative`.
  final bool signed;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final onCard = colors.onPrimary;
    final radius = BorderRadius.circular(AppRadius.card);

    return DecoratedBox(
      // Figma "Elevation/FAB": an emerald glow under the card.
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(borderRadius: radius),
        shadows: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.32),
            blurRadius: 24,
            spreadRadius: -6,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRSuperellipse(
        borderRadius: radius,
        child: ColoredBox(
          color: colors.primary,
          child: Stack(
            children: [
              // Two soft aura glows (bg/aura-2 at the top end, bg/aura-1 at
              // the bottom start), as in the design system component.
              _Glow(color: colors.aura2, size: 220, start: null, end: -90, top: -110),
              _Glow(color: colors.aura1, size: 170, start: -70, end: null, top: 90),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: text.labelLarge!.copyWith(color: onCard.withValues(alpha: 0.85))),
                    const SizedBox(height: AppSpacing.sm),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        signed ? context.signedMoney(total, plus: false) : context.money(total),
                        // The minus sign marks a negative balance; red would be
                        // unreadable on the emerald card.
                        style: text.displayMedium!.copyWith(color: onCard),
                      ),
                    ),
                    if (details.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          for (final detail in details)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    detail.label,
                                    style: text.labelMedium!.copyWith(color: onCard.withValues(alpha: 0.85)),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      context.money(detail.amount),
                                      style: text.titleMedium!.copyWith(color: onCard),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                    if (_comparison(context) case final comparison?) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
                        decoration: ShapeDecoration(
                          shape: const StadiumBorder(),
                          color: colors.inverseSurface.withValues(alpha: 0.16),
                        ),
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
              ),
            ],
          ),
        ),
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

/// A blurred aura disc, positioned partly outside the card (clipped).
class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size, required this.start, required this.end, required this.top});

  final Color color;
  final double size;
  final double? start;
  final double? end;
  final double top;

  @override
  Widget build(BuildContext context) => PositionedDirectional(
    start: start,
    end: end,
    top: top,
    width: size,
    height: size,
    child: IgnorePointer(
      child: ImageFiltered(
        // Figma layer blur 48.
        imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24, tileMode: TileMode.decal),
        child: DecoratedBox(
          decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.4)),
        ),
      ),
    ),
  );
}
