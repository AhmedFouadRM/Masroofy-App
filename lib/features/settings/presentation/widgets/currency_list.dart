import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/presentation/widgets/radio_mark.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A searchable list of the supported currencies with a radio mark on the
/// [selected] one (Figma "Currency picker"). Currencies with 3 fraction
/// digits say so. Shared by the first-launch screen and Settings → Currency.
class CurrencyList extends StatefulWidget {
  const CurrencyList({required this.selected, required this.onSelected, super.key});

  final Currency selected;
  final ValueChanged<Currency> onSelected;

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// Matches the code, the symbol or the name in the current language.
  bool _matches(Currency currency, String query) {
    if (query.isEmpty) return true;
    return [
      currency.code,
      currency.symbolEn,
      currency.symbolAr,
      StringManager.currencyName(currency.code),
    ].any((text) => text.toLowerCase().contains(query));
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final query = _search.text.trim().toLowerCase();
    final matches = CurrencyUtils.supported.where((c) => _matches(c, query)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: StringManager.searchCurrencies,
            prefixIcon: const Icon(Symbols.search_rounded),
            suffixIcon: _search.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Symbols.close_rounded),
                    tooltip: StringManager.clearSearch,
                    onPressed: () => setState(_search.clear),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (matches.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              StringManager.noResults,
              textAlign: TextAlign.center,
              style: text.bodyMedium!.copyWith(color: colors.textSecondary),
            ),
          )
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (index, currency) in matches.indexed) ...[
                  if (index > 0) const Divider(),
                  Semantics(
                    inMutuallyExclusiveGroup: true,
                    selected: currency == widget.selected,
                    child: ListTile(
                      title: Text(StringManager.currencyName(currency.code)),
                      subtitle: Text(
                        currency.fractionDigits == 2
                            ? currency.code
                            : '${currency.code} · ${StringManager.decimals(context.count(currency.fractionDigits))}',
                      ),
                      trailing: RadioMark(selected: currency == widget.selected),
                      onTap: () => widget.onSelected(currency),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
