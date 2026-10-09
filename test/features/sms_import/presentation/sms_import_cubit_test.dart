import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/data/datasources/category_local_datasource.dart';
import 'package:masroofy/features/categories/data/repositories/category_repository_impl.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_outcome.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_permissions.dart';
import 'package:masroofy/features/sms_import/domain/usecases/list_sms_senders.dart';
import 'package:masroofy/features/sms_import/presentation/cubits/sms_import_cubit.dart';

import '../domain/egbank_samples.dart';
import '../sms_test_kit.dart';

class FakePermissions implements ISmsPermissions {
  FakePermissions({this.smsState = SmsPermissionState.denied, this.notifications = false});

  SmsPermissionState smsState;
  bool notifications;

  /// What the next prompt answers.
  SmsPermissionState smsAnswer = SmsPermissionState.granted;
  bool notificationsAnswer = true;
  final List<String> requests = [];
  int openedSettings = 0;

  @override
  Future<SmsPermissionState> sms() async => smsState;

  @override
  Future<bool> notificationsGranted() async => notifications;

  @override
  Future<void> openSystemSettings() async => openedSettings++;

  @override
  Future<bool> requestNotifications() async {
    requests.add('notifications');
    return notifications = notificationsAnswer;
  }

  @override
  Future<SmsPermissionState> requestSms() async {
    requests.add('sms');
    return smsState = smsAnswer;
  }
}

void main() {
  final now = DateTime(2026, 10, 9, 18);
  late SmsTestKit kit;
  late FakePermissions permissions;
  late SmsImportCubit cubit;

  SmsImportCubit build() => SmsImportCubit(
    settings: kit.settings,
    permissions: permissions,
    imports: kit.imports,
    categories: CategoryRepositoryImpl(CategoryLocalDatasource(kit.database)),
    listSenders: ListSmsSenders(imports: kit.imports, inbox: kit.inbox, now: () => now),
    importRecent: kit.importRecent,
    addCatchUp: kit.addCatchUp,
    actions: kit.actions,
    now: () => now,
  );

  setUp(() {
    kit = SmsTestKit(
      now: () => now,
      settings: FakeSmsSettings(enabled: false, mode: SmsMode.ask),
    );
    permissions = FakePermissions();
    cubit = build();
  });
  tearDown(() async {
    await cubit.close();
    await kit.close();
  });

  Future<void> load() async {
    await cubit.load();
    await pumpEventQueue();
  }

  group('load', () {
    test('starts off, asking, with nothing to show', () async {
      await load();

      expect(cubit.state.loading, isFalse);
      expect(cubit.state.enabled, isFalse);
      expect(cubit.state.mode, SmsMode.ask);
      expect(cubit.state.permissionDenied, isFalse);
      expect(cubit.state.recent, isEmpty);
      expect(cubit.state.senders, isEmpty);
      // Off: nothing is asked.
      expect(permissions.requests, isEmpty);
    });

    test('reads what is on: the mode, the senders and the recent imports', () async {
      kit.settings
        ..enabled = true
        ..mode = SmsMode.auto;
      permissions
        ..smsState = SmsPermissionState.granted
        ..notifications = true;
      kit.inbox.messages = [RawSms(sender: 'CIB', body: 'x', receivedAt: DateTime(2026, 10))];
      await kit.handle(
        RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: DateTime(2026, 10, 8, 12)),
      );

      await load();

      expect(cubit.state.enabled, isTrue);
      expect(cubit.state.mode, SmsMode.auto);
      expect(cubit.state.recent.single.merchant, 'Uber');
      expect(cubit.state.categories, isNotEmpty);
      expect(cubit.state.senders.map((s) => s.name), ['CIB', 'EG Bank']);
      expect(cubit.state.notificationsGranted, isTrue);
    });

    test('recent imports are the last 30 days only', () async {
      kit.settings.enabled = true;
      permissions.smsState = SmsPermissionState.granted;
      await kit.handle(
        RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: DateTime(2026, 10, 8, 12)),
      );
      await kit.handle(RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: DateTime(2026, 8)));

      await load();

      expect(cubit.state.recent, hasLength(1));
    });

    test('turns itself off when the permission was revoked in the system settings', () async {
      kit.settings.enabled = true;
      permissions.smsState = SmsPermissionState.denied;

      await load();

      expect(cubit.state.enabled, isFalse);
      expect(cubit.state.permissionDenied, isTrue);
      expect(kit.settings.enabled, isFalse);
    });

    test('tells when Ask mode has no notifications to ask with', () async {
      kit.settings.enabled = true;
      permissions
        ..smsState = SmsPermissionState.granted
        ..notifications = false;

      await load();

      expect(cubit.state.notificationsBlocked, isTrue);
      await cubit.setMode(SmsMode.auto);
      expect(cubit.state.notificationsBlocked, isFalse);
    });

    test('follows the answers about senders', () async {
      kit.settings.enabled = true;
      permissions.smsState = SmsPermissionState.granted;
      await load();

      await kit.actions.setSenderTrusted('BANQUEMIS', trusted: true);
      await pumpEventQueue();

      expect(cubit.state.senders.single.name, 'BANQUEMIS');
      expect(cubit.state.senders.single.addedByUser, isTrue);
    });
  });

  group('turning it on', () {
    test('asks for the SMS permission, then for notifications, and then it is on', () async {
      await load();

      final enabled = await cubit.enable();

      expect(enabled, isTrue);
      expect(permissions.requests, ['sms', 'notifications']);
      expect(cubit.state.enabled, isTrue);
      expect(cubit.state.enabling, isFalse);
      expect(cubit.state.notificationsGranted, isTrue);
      expect(kit.settings.enabled, isTrue);
    });

    test('denying SMS leaves it off with the denied card, and never asks about notifications', () async {
      permissions.smsAnswer = SmsPermissionState.denied;
      await load();

      final enabled = await cubit.enable();

      expect(enabled, isFalse);
      expect(permissions.requests, ['sms']);
      expect(cubit.state.enabled, isFalse);
      expect(cubit.state.permissionDenied, isTrue);
      expect(kit.settings.enabled, isFalse);
    });

    test('a permanent denial is the same', () async {
      permissions.smsAnswer = SmsPermissionState.permanentlyDenied;
      await load();

      expect(await cubit.enable(), isFalse);
      expect(cubit.state.permissionDenied, isTrue);
    });

    test('denying notifications keeps it on, with the notifications note', () async {
      permissions.notificationsAnswer = false;
      await load();

      expect(await cubit.enable(), isTrue);

      expect(cubit.state.enabled, isTrue);
      expect(cubit.state.notificationsGranted, isFalse);
      expect(cubit.state.notificationsBlocked, isTrue);
    });

    test('does not ask again for what is already granted', () async {
      permissions
        ..smsState = SmsPermissionState.granted
        ..notifications = true;
      await load();

      await cubit.enable();

      expect(permissions.requests, isEmpty);
      expect(cubit.state.enabled, isTrue);
    });

    test('a second try after a denial clears the denied card when granted', () async {
      permissions.smsAnswer = SmsPermissionState.denied;
      await load();
      await cubit.enable();
      permissions.smsAnswer = SmsPermissionState.granted;

      await cubit.enable();

      expect(cubit.state.permissionDenied, isFalse);
      expect(cubit.state.enabled, isTrue);
    });

    test('turning it off stops it at once', () async {
      await load();
      await cubit.enable();

      await cubit.disable();

      expect(cubit.state.enabled, isFalse);
      expect(kit.settings.enabled, isFalse);
    });

    test('the permission granted in the system settings clears the card, but the switch stays off', () async {
      permissions.smsAnswer = SmsPermissionState.denied;
      await load();
      await cubit.enable();
      permissions.smsState = SmsPermissionState.granted;

      await cubit.refreshPermissions();

      expect(cubit.state.permissionDenied, isFalse);
      expect(cubit.state.enabled, isFalse);
    });

    test('opens the system settings', () async {
      await cubit.openSystemSettings();

      expect(permissions.openedSettings, 1);
    });
  });

  group('the mode', () {
    test('is remembered', () async {
      await load();

      await cubit.setMode(SmsMode.auto);

      expect(cubit.state.mode, SmsMode.auto);
      expect(kit.settings.mode, SmsMode.auto);
    });
  });

  group('trusted senders', () {
    test('the switch of a built-in sender', () async {
      kit.settings.enabled = true;
      permissions.smsState = SmsPermissionState.granted;
      kit.inbox.messages = [RawSms(sender: 'CIB', body: 'x', receivedAt: DateTime(2026, 10))];
      await load();

      await cubit.setSenderTrusted(cubit.state.senders.single, trusted: false);
      await pumpEventQueue();

      expect(cubit.state.senders.single.trusted, isFalse);
      expect((await kit.imports.trustOf('cib')).getOrElse((_) => null), isFalse);
    });
  });

  group('delete import history', () {
    test('clears the list and keeps the transactions', () async {
      kit.settings
        ..enabled = true
        ..mode = SmsMode.auto;
      permissions.smsState = SmsPermissionState.granted;
      await kit.handle(
        RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: DateTime(2026, 10, 8, 12)),
      );
      await load();
      expect(cubit.state.recent, hasLength(1));

      expect(await cubit.deleteHistory(), isTrue);
      await pumpEventQueue();

      expect(cubit.state.recent, isEmpty);
      expect(await kit.allExpenses(), hasLength(1));
    });
  });

  group('catch-up', () {
    setUp(() {
      kit.settings.enabled = true;
      permissions.smsState = SmsPermissionState.granted;
      kit.inbox.messages = [
        RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: DateTime(2026, 10, 8, 12)),
        RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseGeidea, receivedAt: DateTime(2026, 10, 9, 9)),
        RawSms(sender: 'EGBANK', body: EgBankSamples.instaPayCredit, receivedAt: DateTime(2026, 10, 7, 14, 40)),
      ];
    });

    test('is offered once', () async {
      expect(await cubit.catchUpDue(), isTrue);

      await cubit.markCatchUpOffered();

      expect(await cubit.catchUpDue(), isFalse);
    });

    test('scans, checks everything and adds what is checked, whatever the mode', () async {
      kit.settings.mode = SmsMode.ask;
      await load();

      await cubit.startCatchUp();

      final review = cubit.state.catchUp!;
      expect(review.status, CatchUpStatus.ready);
      expect(review.candidates, hasLength(3));
      expect(review.selectedCount, 3);

      cubit.toggleCandidate(review.candidates.first.smsKey);
      expect(cubit.state.catchUp!.selectedCount, 2);

      final added = await cubit.addSelected();

      expect(added, 2);
      expect(cubit.state.catchUp, isNull);
      expect(await kit.allExpenses(), hasLength(2));
      await pumpEventQueue();
      expect(cubit.state.recent, hasLength(2));
    });

    test('likely duplicates start unchecked', () async {
      await kit.addManual(amountMinor: 500, date: DateTime(2026, 10, 8).toLocalDateForTest());
      await load();

      await cubit.startCatchUp();

      final review = cubit.state.catchUp!;
      final duplicate = review.candidates.singleWhere((c) => c.likelyDuplicate);
      expect(duplicate.parsed.merchant, 'Uber');
      expect(review.selected, isNot(contains(duplicate.smsKey)));
      expect(review.selectedCount, 2);

      // The user can still check it.
      cubit.toggleCandidate(duplicate.smsKey);
      expect(cubit.state.catchUp!.selectedCount, 3);
    });

    test('adds nothing for an unchecked list, and skip closes it', () async {
      await load();
      await cubit.startCatchUp();
      for (final candidate in cubit.state.catchUp!.candidates) {
        cubit.toggleCandidate(candidate.smsKey);
      }

      expect(cubit.state.catchUp!.selectedCount, 0);
      expect(await kit.allExpenses(), isEmpty);

      cubit.closeCatchUp();
      expect(cubit.state.catchUp, isNull);
      expect(await kit.allExpenses(), isEmpty);
    });

    test('an empty inbox is an empty review', () async {
      kit.inbox.messages = [];
      await load();

      await cubit.startCatchUp();

      expect(cubit.state.catchUp!.status, CatchUpStatus.ready);
      expect(cubit.state.catchUp!.candidates, isEmpty);
    });

    test('an unreadable inbox is a failed review', () async {
      kit.inbox.failure = const Failure.unexpected(error: 'no permission');
      await load();

      await cubit.startCatchUp();

      expect(cubit.state.catchUp!.status, CatchUpStatus.failed);
    });

    test('shows the scan while it runs, and ignores toggles before it is ready', () async {
      await load();

      final scan = cubit.startCatchUp();
      expect(cubit.state.catchUp!.status, CatchUpStatus.scanning);
      cubit.toggleCandidate('whatever');
      await scan;

      expect(cubit.state.catchUp!.status, CatchUpStatus.ready);
    });

    test('re-scanning after adding offers nothing again', () async {
      await load();
      await cubit.startCatchUp();
      await cubit.addSelected();

      await cubit.startCatchUp();

      expect(cubit.state.catchUp!.candidates, isEmpty);
      expect(await kit.allExpenses(), hasLength(3));
    });

    test('an import from the catch-up shows as added in Recent imports', () async {
      await load();
      await cubit.startCatchUp();
      await cubit.addSelected();
      await pumpEventQueue();

      expect(cubit.state.recent.every((i) => i.status == SmsImportStatus.added), isTrue);
    });

    test('a new message while the screen is open shows up, pending', () async {
      kit.settings.mode = SmsMode.ask;
      await load();

      final outcome = await kit.handle(
        RawSms(sender: 'EGBANK', body: EgBankSamples.purchaseUber, receivedAt: DateTime(2026, 10, 9, 10)),
      );
      await pumpEventQueue();

      expect(outcome.getOrElse((_) => throw StateError('')), isA<SmsNeedsReview>());
      expect(cubit.state.recent.single.status, SmsImportStatus.pending);
    });
  });
}

extension on DateTime {
  LocalDate toLocalDateForTest() => LocalDate.fromDateTime(this);
}
