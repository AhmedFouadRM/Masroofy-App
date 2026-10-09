import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/presentation/screens/currency_picker_screen.dart';
import 'package:masroofy/features/settings/presentation/screens/first_launch_screen.dart';
import 'package:masroofy/features/settings/presentation/widgets/radio_mark.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/router_host.dart';

void main() {
  late MockSettingsCubit settings;

  setUpAll(() => registerFallbackValue(CurrencyUtils.defaultCurrency));

  setUp(() {
    settings = MockSettingsCubit();
    when(() => settings.state).thenReturn(testSettings());
    when(() => settings.completeFirstLaunch(any())).thenAnswer((_) async {});
    when(() => settings.setCurrency(any())).thenAnswer((_) async {});
  });

  Future<void> tallView(WidgetTester tester) async {
    tester.view
      ..physicalSize = const Size(400, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  bool isSelected(WidgetTester tester, String name) => tester
      .widget<RadioMark>(find.descendant(of: find.widgetWithText(ListTile, name), matching: find.byType(RadioMark)))
      .selected;

  group('FirstLaunchScreen', () {
    Future<void> pumpFirstLaunch(WidgetTester tester, {Locale locale = const Locale('en')}) async {
      await tallView(tester);
      await pumpApp(
        tester,
        const FirstLaunchScreen(),
        locale: locale,
        providers: [BlocProvider<SettingsCubit>.value(value: settings)],
      );
    }

    testWidgets('asks for a currency, with EGP preselected', (tester) async {
      await pumpFirstLaunch(tester);

      expect(find.text('Choose your currency'), findsOneWidget);
      expect(find.text('Amounts are shown in it. You can change it later in Settings.'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(isSelected(tester, 'Egyptian Pound'), isTrue);
      expect(isSelected(tester, 'Saudi Riyal'), isFalse);
      expect(find.byType(ListTile), findsNWidgets(CurrencyUtils.supported.length));
    });

    testWidgets('3-decimal currencies say so', (tester) async {
      await pumpFirstLaunch(tester);

      expect(find.text('KWD · 3 decimals'), findsOneWidget);
      expect(find.text('BHD · 3 decimals'), findsOneWidget);
      expect(find.text('OMR · 3 decimals'), findsOneWidget);
      expect(find.text('JOD · 3 decimals'), findsOneWidget);
      expect(find.text('EGP'), findsOneWidget);
      expect(find.textContaining('decimals'), findsNWidgets(4));
    });

    testWidgets('Continue stores the preselected currency', (tester) async {
      await pumpFirstLaunch(tester);

      await tester.tap(find.text('Continue'));

      verify(() => settings.completeFirstLaunch(CurrencyUtils.defaultCurrency)).called(1);
    });

    testWidgets('picking another currency moves the selection and Continue stores it', (tester) async {
      await pumpFirstLaunch(tester);

      await tester.tap(find.text('Kuwaiti Dinar'));
      await tester.pump();
      expect(isSelected(tester, 'Kuwaiti Dinar'), isTrue);
      expect(isSelected(tester, 'Egyptian Pound'), isFalse);
      await tester.tap(find.text('Continue'));

      verify(() => settings.completeFirstLaunch(CurrencyUtils.byCode('KWD')!)).called(1);
    });

    testWidgets('search narrows the list by name, code or symbol, and clears', (tester) async {
      await pumpFirstLaunch(tester);

      await tester.enterText(find.byType(TextField), 'kuw');
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Kuwaiti Dinar'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'gbp');
      await tester.pump();
      expect(find.text('British Pound'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);

      await tester.enterText(find.byType(TextField), '€');
      await tester.pump();
      expect(find.text('Euro'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('No results found'), findsOneWidget);

      await tester.tap(find.byTooltip('Clear search'));
      await tester.pump();
      expect(find.byType(ListTile), findsNWidgets(CurrencyUtils.supported.length));
    });

    testWidgets('a hidden selection still wins: search does not change the choice', (tester) async {
      await pumpFirstLaunch(tester);
      await tester.tap(find.text('Euro'));
      await tester.enterText(find.byType(TextField), 'kuw');
      await tester.pump();
      await tester.tap(find.text('Continue'));

      verify(() => settings.completeFirstLaunch(CurrencyUtils.byCode('EUR')!)).called(1);
    });

    testWidgets('Arabic: translated names, Eastern digits, search by Arabic name', (tester) async {
      await pumpFirstLaunch(tester, locale: const Locale('ar'));

      expect(find.text('اختر عملتك'), findsOneWidget);
      expect(find.text('متابعة'), findsOneWidget);
      expect(find.text('KWD · ٣ منازل عشرية'), findsOneWidget);
      expect(isSelected(tester, 'جنيه مصري'), isTrue);

      await tester.enterText(find.byType(TextField), 'كويتي');
      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
    });
  });

  group('CurrencyPickerScreen', () {
    Future<void> pumpPicker(WidgetTester tester, {Locale locale = const Locale('en')}) async {
      await tallView(tester);
      await pumpApp(
        tester,
        RouterHost(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => Scaffold(
                body: TextButton(onPressed: () => context.push('/currency'), child: const Text('open')),
              ),
            ),
            GoRoute(path: '/currency', builder: (context, state) => const CurrencyPickerScreen()),
          ],
        ),
        locale: locale,
        providers: [BlocProvider<SettingsCubit>.value(value: settings)],
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('lists the currencies with the current one selected', (tester) async {
      await pumpPicker(tester);

      expect(find.text('Currency'), findsOneWidget);
      expect(isSelected(tester, 'Egyptian Pound'), isTrue);
      expect(find.text('KWD · 3 decimals'), findsOneWidget);
    });

    testWidgets('changing currency warns that amounts are rescaled, not converted', (tester) async {
      await pumpPicker(tester);

      await tester.tap(find.text('Kuwaiti Dinar'));
      await tester.pumpAndSettle();

      expect(find.text('Change to Kuwaiti Dinar?'), findsOneWidget);
      expect(
        find.text("Existing amounts won't be converted: EGP 12.50 becomes KWD 12.500. Only the currency changes."),
        findsOneWidget,
      );
      verifyNever(() => settings.setCurrency(any()));
    });

    testWidgets('Change switches the currency and closes the picker', (tester) async {
      await pumpPicker(tester);

      await tester.tap(find.text('Kuwaiti Dinar'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Change'));
      await tester.pumpAndSettle();

      verify(() => settings.setCurrency(CurrencyUtils.byCode('KWD')!)).called(1);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('Cancel keeps the currency and the picker', (tester) async {
      await pumpPicker(tester);

      await tester.tap(find.text('Kuwaiti Dinar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => settings.setCurrency(any()));
      expect(find.text('Currency'), findsOneWidget);
    });

    testWidgets('a switch between 2-decimal currencies shows the same face value', (tester) async {
      await pumpPicker(tester);

      await tester.tap(find.text('US Dollar'));
      await tester.pumpAndSettle();

      expect(
        find.text(r"Existing amounts won't be converted: EGP 12.50 becomes $12.50. Only the currency changes."),
        findsOneWidget,
      );
    });

    testWidgets('choosing the current currency just closes', (tester) async {
      await pumpPicker(tester);

      await tester.tap(find.text('Egyptian Pound'));
      await tester.pumpAndSettle();

      verifyNever(() => settings.setCurrency(any()));
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('Arabic warning uses Eastern digits and the Arabic symbols', (tester) async {
      await pumpPicker(tester, locale: const Locale('ar'));

      await tester.tap(find.text('دينار كويتي'));
      await tester.pumpAndSettle();

      expect(find.text('التغيير إلى دينار كويتي؟'), findsOneWidget);
      expect(
        find.text('لن يتم تحويل المبالغ الحالية: ١٢٫٥٠ ج.م. يصبح ١٢٫٥٠٠ د.ك. (تتغير العملة فقط).'),
        findsOneWidget,
      );
    });
  });
}
