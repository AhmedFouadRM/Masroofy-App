import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/features/wallets/domain/wallet_icons.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallet_form_cubit.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallets_cubit.dart';
import 'package:masroofy/features/wallets/presentation/screens/wallet_form_screen.dart';
import 'package:masroofy/features/wallets/presentation/screens/wallets_screen.dart';
import 'package:masroofy/shared/wallets/default_badge.dart';
import 'package:masroofy/shared/wallets/wallet_icon_registry.dart';
import 'package:masroofy/shared/widgets/color_option.dart';
import 'package:masroofy/shared/widgets/icon_option.dart';
import 'package:masroofy/shared/widgets/select_field.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/router_host.dart';

class _MockWallets extends MockCubit<WalletsState> implements WalletsCubit {}

class _MockForm extends MockCubit<WalletFormState> implements WalletFormCubit {}

final _epoch = DateTime.utc(2026);

Wallet _wallet(int id, {String? name, String icon = 'child'}) => Wallet(
  id: id,
  seedKey: id == 1 ? 'me' : null,
  name: id == 1 ? null : (name ?? 'Wallet $id'),
  icon: id == 1 ? 'person' : icon,
  color: 0xFF3B82F6,
  sortOrder: id,
  createdAt: _epoch,
  updatedAt: _epoch,
);

WalletSummary _summary(
  int id, {
  String? name,
  int balance = 0,
  int rows = 0,
  int transfers = 0,
  int templates = 0,
}) => WalletSummary(
  wallet: _wallet(id, name: name),
  balance: Money(balance),
  transactionCount: rows,
  transferCount: transfers,
  templateCount: templates,
);

void main() {
  group('WalletsScreen', () {
    late _MockWallets cubit;
    late List<String> opened;
    final loaded = WalletsState(
      status: WalletsStatus.loaded,
      wallets: [
        _summary(1, balance: 450000),
        _summary(2, name: 'Son', balance: 50000),
      ],
    );

    setUp(() {
      cubit = _MockWallets();
      opened = [];
    });

    Future<void> pump(
      WidgetTester tester,
      WalletsState state, {
      Locale locale = const Locale('en'),
      int? defaultId = 1,
    }) {
      when(() => cubit.state).thenReturn(state);
      return pumpApp(
        tester,
        RouterHost(
          routes: [
            GoRoute(path: '/', builder: (context, _) => const WalletsScreen()),
            for (final path in [RoutePaths.newWallet, RoutePaths.editWallet(2), RoutePaths.editWallet(1)])
              GoRoute(
                path: path,
                builder: (context, _) {
                  opened.add(path);
                  return Text('opened $path');
                },
              ),
          ],
        ),
        locale: locale,
        settings: testSettings(defaultWalletId: defaultId),
        providers: [BlocProvider<WalletsCubit>.value(value: cubit)],
      );
    }

    testWidgets('lists each wallet with its balance this month, and the Default badge on one', (tester) async {
      await pump(tester, loaded);

      expect(find.text('Wallets'), findsNWidgets(2), reason: 'the app bar and the section');
      expect(find.text('2'), findsOneWidget, reason: 'how many');
      expect(find.text('Me'), findsOneWidget);
      expect(find.text('Son'), findsOneWidget);
      expect(find.text('EGP 4,500 this month'), findsOneWidget);
      expect(find.text('EGP 500 this month'), findsOneWidget);
      expect(find.byType(DefaultBadge), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
      // The badge is beside Me, not Son.
      expect(
        (tester.getCenter(find.byType(DefaultBadge)).dy - tester.getCenter(find.text('Me')).dy).abs(),
        lessThan(20),
      );
    });

    testWidgets('each wallet has its icon and colour avatar', (tester) async {
      await pump(tester, loaded);

      expect(find.byIcon(Symbols.person_rounded), findsOneWidget);
      expect(find.byIcon(Symbols.child_care_rounded), findsOneWidget);
    });

    testWidgets('the Default badge follows the default wallet', (tester) async {
      await pump(tester, loaded, defaultId: 2);

      expect(
        (tester.getCenter(find.byType(DefaultBadge)).dy - tester.getCenter(find.text('Son')).dy).abs(),
        lessThan(20),
      );
    });

    testWidgets('a negative balance shows a minus sign', (tester) async {
      await pump(tester, WalletsState(status: WalletsStatus.loaded, wallets: [_summary(1, balance: -20000)]));

      expect(find.text('−EGP 200 this month'), findsOneWidget);
    });

    testWidgets('the + button adds a wallet, and a row edits it', (tester) async {
      await pump(tester, loaded);

      await tester.tap(find.byTooltip('Add wallet'));
      await tester.pumpAndSettle();
      expect(opened, [RoutePaths.newWallet]);
    });

    testWidgets('tapping a wallet opens it', (tester) async {
      await pump(tester, loaded);

      await tester.tap(find.text('Son'));
      await tester.pumpAndSettle();
      expect(opened, [RoutePaths.editWallet(2)]);
    });

    testWidgets('shows the failure when loading fails', (tester) async {
      await pump(
        tester,
        const WalletsState(
          status: WalletsStatus.failure,
          loadFailure: Failure.storage(message: 'disk'),
        ),
      );

      expect(find.text("Couldn't save your data. Please try again"), findsOneWidget);
    });

    testWidgets('Arabic: translated, right to left, with Eastern digits', (tester) async {
      await pump(tester, loaded, locale: const Locale('ar'));

      expect(find.text('المحافظ'), findsNWidgets(2));
      expect(find.text('أنا'), findsOneWidget);
      expect(find.text('افتراضية'), findsOneWidget);
      expect(find.text('٤٬٥٠٠ ج.م. هذا الشهر'), findsOneWidget);
      expect(find.text('٢'), findsOneWidget);
      expect(Directionality.of(tester.element(find.text('أنا'))), TextDirection.rtl);
    });

    testWidgets('typed names take the direction of their own text', (tester) async {
      await pump(
        tester,
        WalletsState(
          status: WalletsStatus.loaded,
          wallets: [
            _summary(1),
            _summary(2, name: 'ابني'),
            _summary(3, name: 'Home'),
          ],
        ),
      );

      expect(tester.widget<Text>(find.text('ابني')).textDirection, TextDirection.rtl);
      expect(tester.widget<Text>(find.text('Home')).textDirection, TextDirection.ltr);
    });
  });

  group('WalletFormScreen', () {
    late _MockForm cubit;
    late MockSettingsCubit settings;

    final wallets = [_summary(1, rows: 3), _summary(2, name: 'Son', rows: 12, templates: 1, transfers: 2)];
    final ready = WalletFormState(
      icon: 'person',
      color: 0xFF059669,
      status: WalletFormStatus.ready,
      wallets: wallets,
    );
    final editingSon = ready.copyWith(
      id: 2,
      wallet: _wallet(2, name: 'Son'),
      name: 'Son',
      icon: 'child',
      color: 0xFF3B82F6,
    );
    final editingMe = ready.copyWith(id: 1, wallet: _wallet(1), makeDefault: true, wasDefault: true);

    setUp(() {
      cubit = _MockForm();
      settings = MockSettingsCubit();
      when(() => cubit.save()).thenAnswer((_) async {});
      when(() => cubit.delete(moveTo: any(named: 'moveTo'))).thenAnswer((_) async {});
    });

    /// The form is pushed above a home page, so it can pop itself.
    Future<void> pump(
      WidgetTester tester,
      WalletFormState state, {
      Stream<WalletFormState>? states,
      Locale locale = const Locale('en'),
      int? defaultId = 1,
      int? viewedId,
    }) async {
      tester.view
        ..physicalSize = const Size(400, 1800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      whenListen(cubit, states ?? const Stream<WalletFormState>.empty(), initialState: state);
      await pumpApp(
        tester,
        RouterHost(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, _) => Scaffold(
                body: TextButton(onPressed: () => context.push('/form'), child: const Text('open')),
              ),
            ),
            GoRoute(path: '/form', builder: (context, _) => const WalletFormScreen()),
          ],
        ),
        locale: locale,
        settings: testSettings(defaultWalletId: defaultId, viewedWalletId: viewedId),
        settingsCubit: settings,
        providers: [BlocProvider<WalletFormCubit>.value(value: cubit)],
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('a new wallet: a live preview, the name, 8 icons, colours, and no default switch or delete', (
      tester,
    ) async {
      await pump(tester, ready);

      expect(find.text('New wallet'), findsNWidgets(2), reason: 'the app bar and the empty preview');
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Up to 30 characters'), findsOneWidget);
      expect(find.text('Icon'), findsOneWidget);
      expect(find.text('Colour'), findsOneWidget);
      expect(find.byType(IconOption), findsNWidgets(8));
      expect(find.byType(ColorOption), findsNWidgets(9));
      expect(find.text('Set as default'), findsNothing);
      expect(find.text('Delete wallet'), findsNothing);
      final save = tester.widget<TextButton>(find.widgetWithText(TextButton, 'Save'));
      expect(save.onPressed, isNull, reason: 'a name is required');
    });

    testWidgets('the icons are the eight curated ones', (tester) async {
      await pump(tester, ready);

      for (final key in WalletIcons.keys) {
        expect(find.byIcon(WalletIconRegistry.of(key)), findsWidgets, reason: key);
      }
    });

    testWidgets('typing a name, and picking an icon and a colour, tell the cubit', (tester) async {
      await pump(tester, ready);

      await tester.enterText(find.byType(TextField), 'Wife');
      verify(() => cubit.nameChanged('Wife')).called(1);

      await tester.tap(find.byIcon(Symbols.woman_rounded));
      verify(() => cubit.iconSelected('woman')).called(1);

      await tester.tap(find.byType(ColorOption).at(2));
      verify(() => cubit.colorSelected(any())).called(1);
    });

    testWidgets('Save is on once there is a name, and saves', (tester) async {
      await pump(tester, ready.copyWith(name: 'Wife'));

      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      verify(() => cubit.save()).called(1);
    });

    testWidgets('a duplicate name is refused under the field', (tester) async {
      await pump(tester, ready.copyWith(name: 'Son', nameError: ValidationReason.duplicate));

      expect(find.text('This name is already used'), findsOneWidget);
    });

    testWidgets('editing: the wallet, with Set as default and Delete', (tester) async {
      await pump(
        tester,
        ready.copyWith(status: WalletFormStatus.loading, id: 2),
        states: Stream.value(editingSon),
      );

      expect(find.text('Edit wallet'), findsOneWidget);
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'Son');
      expect(find.text('Set as default'), findsOneWidget);
      expect(find.text('Delete wallet'), findsOneWidget);
      expect(find.text('New default wallet'), findsNothing);
    });

    testWidgets('editing Me shows its translated name', (tester) async {
      await pump(tester, ready.copyWith(status: WalletFormStatus.loading, id: 1), states: Stream.value(editingMe));
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'Me');
    });

    testWidgets('editing Me in Arabic shows أنا', (tester) async {
      await pump(
        tester,
        ready.copyWith(status: WalletFormStatus.loading, id: 1),
        states: Stream.value(editingMe),
        locale: const Locale('ar'),
      );

      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, 'أنا');
      expect(find.text('تعيين كمحفظة افتراضية'), findsOneWidget);
      expect(find.text('حذف المحفظة'), findsOneWidget);
    });

    testWidgets('Set as default can be switched on', (tester) async {
      await pump(tester, editingSon);

      await tester.tap(find.byType(Switch));
      verify(() => cubit.defaultChanged(value: true)).called(1);
    });

    testWidgets("the default wallet's switch is on and locked: make another wallet the default instead", (
      tester,
    ) async {
      await pump(tester, editingMe);

      final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
      expect(tile.value, isTrue);
      expect(tile.onChanged, isNull);
      expect(find.text('To change the default, set another wallet as the default.'), findsOneWidget);
    });

    testWidgets('saving with Set as default on makes it the default wallet, and closes the form', (tester) async {
      await pump(
        tester,
        editingSon.copyWith(makeDefault: true),
        states: Stream.value(editingSon.copyWith(makeDefault: true, status: WalletFormStatus.saved)),
      );
      await tester.pumpAndSettle();

      verify(() => settings.setDefaultWallet(2)).called(1);
      expect(find.text('Edit wallet'), findsNothing, reason: 'popped');
    });

    testWidgets('saving without it leaves the default alone', (tester) async {
      await pump(
        tester,
        editingSon,
        states: Stream.value(editingSon.copyWith(status: WalletFormStatus.saved)),
      );
      await tester.pumpAndSettle();

      verifyNever(() => settings.setDefaultWallet(any()));
      expect(find.text('Edit wallet'), findsNothing);
    });

    testWidgets("the last wallet can't be deleted", (tester) async {
      await pump(tester, editingMe.copyWith(wallets: [_summary(1)]));

      expect(find.text('You need at least one wallet.'), findsOneWidget);
      final button = tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Delete wallet'));
      expect(button.onPressed, isNull);
    });

    testWidgets('deleting an empty wallet only asks to confirm', (tester) async {
      await pump(
        tester,
        editingSon.copyWith(
          wallets: [
            _summary(1),
            _summary(2, name: 'Son'),
          ],
        ),
      );

      await tester.tap(find.text('Delete wallet'));
      await tester.pumpAndSettle();
      expect(find.text('Delete “Son”?'), findsOneWidget);
      expect(find.text('This wallet has no transactions.'), findsOneWidget);
      expect(find.text('Move transactions to'), findsNothing);
      expect(find.text('New default wallet'), findsNothing);

      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      verify(() => cubit.delete()).called(1);
      verifyNever(() => settings.setDefaultWallet(any()));
    });

    testWidgets('cancelling the delete keeps the wallet', (tester) async {
      await pump(tester, editingSon);

      await tester.tap(find.text('Delete wallet'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => cubit.delete(moveTo: any(named: 'moveTo')));
    });

    testWidgets('a wallet with transactions asks where to move them, then deletes', (tester) async {
      await pump(tester, editingSon);

      await tester.tap(find.text('Delete wallet'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          '12 transactions and 1 recurring template will move to the wallet you choose. '
          'Transfers with this wallet become ordinary expenses and income.',
        ),
        findsOneWidget,
      );
      expect(find.text('Move transactions to'), findsOneWidget);
      // The default wallet that stays is the first choice.
      expect(find.descendant(of: find.byType(AlertDialog), matching: find.text('Me')), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      verify(() => cubit.delete(moveTo: 1)).called(1);
    });

    testWidgets('the target of the move can be another wallet', (tester) async {
      final three = [_summary(1), _summary(2, name: 'Son', rows: 4), _summary(3, name: 'Wife')];
      await pump(tester, editingSon.copyWith(wallets: three));

      await tester.tap(find.text('Delete wallet'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(SelectField).last);
      await tester.pumpAndSettle();
      expect(find.text('Choose wallet'), findsOneWidget);
      expect(
        find.text('Son'),
        findsOneWidget,
        reason: 'the wallet being deleted is not offered... except in the title',
      );
      await tester.tap(find.text('Wife').last);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      verify(() => cubit.delete(moveTo: 3)).called(1);
    });

    testWidgets('deleting the default wallet first asks which wallet becomes the default', (tester) async {
      await pump(
        tester,
        editingMe.copyWith(
          wallets: [
            _summary(1, rows: 3),
            _summary(2, name: 'Son'),
            _summary(3, name: 'Wife'),
          ],
        ),
      );

      await tester.tap(find.text('Delete wallet'));
      await tester.pumpAndSettle();
      expect(find.text('This is your default wallet. Choose which wallet takes its place.'), findsOneWidget);
      expect(find.text('New default wallet'), findsOneWidget);
      expect(find.text('Move transactions to'), findsOneWidget);

      await tester.tap(find.byType(SelectField).last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Wife').last);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      // The default moves before the wallet goes.
      verifyInOrder([() => settings.setDefaultWallet(3), () => cubit.delete(moveTo: 2)]);
    });

    testWidgets('after a delete, a wallet that was being viewed gives way to All wallets', (tester) async {
      await pump(
        tester,
        editingSon,
        viewedId: 2,
        states: Stream.value(editingSon.copyWith(status: WalletFormStatus.deleted)),
      );
      await tester.pumpAndSettle();

      verify(() => settings.setViewedWallet(null)).called(1);
      expect(find.text('Edit wallet'), findsNothing);
    });

    testWidgets('after a delete, another wallet being viewed stays', (tester) async {
      await pump(
        tester,
        editingSon,
        viewedId: 1,
        states: Stream.value(editingSon.copyWith(status: WalletFormStatus.deleted)),
      );
      await tester.pumpAndSettle();

      verifyNever(() => settings.setViewedWallet(any()));
    });

    testWidgets('the delete dialog in Arabic', (tester) async {
      await pump(tester, editingSon, locale: const Locale('ar'));

      await tester.tap(find.text('حذف المحفظة'));
      await tester.pumpAndSettle();

      expect(find.text('حذف «Son»؟'), findsOneWidget);
      expect(find.text('نقل المعاملات إلى'), findsOneWidget);
      expect(find.textContaining('١٢ معاملة'), findsOneWidget);
    });

    testWidgets('a load failure shows the message', (tester) async {
      await pump(
        tester,
        ready.copyWith(status: WalletFormStatus.loadFailure, failure: const Failure.notFound()),
      );

      expect(find.text('This item no longer exists'), findsOneWidget);
    });
  });
}
