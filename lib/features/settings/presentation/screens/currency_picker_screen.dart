import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/presentation/widgets/currency_list.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/icon_dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Settings → Currency. Picking another currency first shows what happens to
/// existing amounts (Settings PRD → Changing currency), then switches.
class CurrencyPickerScreen extends StatelessWidget {
  const CurrencyPickerScreen({super.key});

  /// "EGP 12.50" / "KWD 12.500": the same face value in [currency].
  static String _example(BuildContext context, Currency currency) {
    final westernDigits = context.read<SettingsCubit>().state.westernDigits;
    return CurrencyUtils.format(
      Money(1250 * pow(10, currency.fractionDigits - 2).toInt()),
      currency,
      languageCode: context.locale.languageCode,
      westernDigits: westernDigits,
    );
  }

  Future<void> _select(BuildContext context, Currency currency) async {
    final settings = context.read<SettingsCubit>();
    final router = GoRouter.of(context);
    if (currency == settings.state.currency) {
      router.pop();
      return;
    }
    final confirmed = await showIconConfirmDialog(
      context,
      icon: Symbols.currency_exchange_rounded,
      title: StringManager.changeCurrencyTitle(StringManager.currencyName(currency.code)),
      message: StringManager.changeCurrencyBody(
        _example(context, settings.state.currency),
        _example(context, currency),
      ),
      confirmLabel: StringManager.change,
    );
    if (!confirmed) return;
    await settings.setCurrency(currency);
    router.pop();
  }

  @override
  Widget build(BuildContext context) {
    final selected = context.select<SettingsCubit, Currency>((cubit) => cubit.state.currency);
    return AuraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: GlassAppBar(title: Text(StringManager.currency)),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            MediaQuery.paddingOf(context).top + kToolbarHeight + AppSpacing.sm,
            AppSpacing.screen,
            AppSpacing.xl,
          ),
          children: [CurrencyList(selected: selected, onSelected: (currency) => _select(context, currency))],
        ),
      ),
    );
  }
}
