import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/digits.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';

/// Locale- and settings-aware formatting for widgets: Eastern Arabic digits
/// in Arabic unless the user chose Western digits, and the app currency.
/// Rebuilds the caller when the language, digits or currency change.
extension DisplayFormat on BuildContext {
  bool get _arabic => locale.languageCode == 'ar';

  bool get _westernDigits => select<SettingsCubit, bool>((cubit) => cubit.state.westernDigits);

  /// A plain count: `12` / `١٢`.
  String count(int value) => _arabic && !_westernDigits ? toEasternArabicNumber('$value') : '$value';

  /// An amount in the app currency: `EGP 2,000.00` / `٢٬٠٠٠٫٠٠ ج.م.`.
  String money(Money amount) => CurrencyUtils.format(
    amount,
    select<SettingsCubit, Currency>((cubit) => cubit.state.currency),
    languageCode: locale.languageCode,
    westernDigits: _westernDigits,
  );
}
