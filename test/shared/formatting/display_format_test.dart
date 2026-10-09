import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/shared/formatting/display_format.dart';

import '../../helpers/pump_app.dart';

// Bidi isolates that keep the sign before the number in both directions.
const _lri = '\u2066';
const _pdi = '\u2069';

void main() {
  late List<String> shown;

  Future<void> pumpAmounts(WidgetTester tester, {Locale locale = const Locale('en')}) => pumpApp(
    tester,
    Builder(
      builder: (context) {
        shown = [
          context.signedMoney(const Money(500000)),
          context.signedMoney(const Money(-20000)),
          context.signedMoney(Money.zero),
          context.signedMoney(const Money(500000), plus: false),
          context.signedMoney(const Money(-20000), plus: false),
        ];
        return const SizedBox();
      },
    ),
    locale: locale,
  );

  testWidgets('signedMoney puts the sign before the amount, inside an LTR isolate', (tester) async {
    await pumpAmounts(tester);

    expect(shown, [
      '$_lri+EGP 5,000$_pdi',
      '$_lri−EGP 200$_pdi',
      '${_lri}EGP 0$_pdi',
      '${_lri}EGP 5,000$_pdi',
      '$_lri−EGP 200$_pdi',
    ]);
  });

  testWidgets('signedMoney in Arabic keeps the sign first, with Eastern digits', (tester) async {
    await pumpAmounts(tester, locale: const Locale('ar'));

    expect(shown[0], '$_lri+٥٬٠٠٠ ج.م.$_pdi');
    expect(shown[1], '$_lri−٢٠٠ ج.م.$_pdi');
  });
}
