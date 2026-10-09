import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_sender_entry.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_permissions.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/usecases/add_catch_up_selection.dart';
import 'package:masroofy/features/sms_import/domain/usecases/import_recent.dart';
import 'package:masroofy/features/sms_import/domain/usecases/list_sms_senders.dart';
import 'package:masroofy/features/sms_import/domain/usecases/sms_import_actions.dart';
import 'package:masroofy/features/sms_import/presentation/cubits/sms_import_state.dart';

export 'package:masroofy/features/sms_import/presentation/cubits/sms_import_state.dart';

/// The SMS Import screen (Settings → Add from SMS): the switch with its
/// permission prompts, the mode, the trusted senders, the recent imports, and
/// the catch-up review.
class SmsImportCubit extends Cubit<SmsImportState> {
  SmsImportCubit({
    required this._settings,
    required this._permissions,
    required this._imports,
    required this._categories,
    required this._listSenders,
    required this._importRecent,
    required this._addCatchUp,
    required this._actions,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       super(const SmsImportState());

  final ISmsSettings _settings;
  final ISmsPermissions _permissions;
  final ISmsImportRepository _imports;
  final ICategoryRepository _categories;
  final ListSmsSenders _listSenders;
  final ImportRecent _importRecent;
  final AddCatchUpSelection _addCatchUp;
  final SmsImportActions _actions;
  final DateTime Function() _now;

  StreamSubscription<void>? _recentSub;
  StreamSubscription<void>? _trustSub;
  StreamSubscription<void>? _categoriesSub;

  /// The window of Recent imports and of the catch-up scan.
  static const int days = ImportRecent.defaultDays;

  Future<void> load() async {
    final settings = await _settings.load();
    var enabled = settings.enabled;
    var permissionDenied = false;
    var notifications = true;
    if (enabled) {
      // The permission may have been revoked in the system settings.
      if (await _permissions.sms() != SmsPermissionState.granted) {
        enabled = false;
        permissionDenied = true;
        await _settings.setEnabled(enabled: false);
      } else {
        notifications = await _permissions.notificationsGranted();
      }
    }
    if (isClosed) return;
    emit(
      state.copyWith(
        loading: false,
        enabled: enabled,
        mode: settings.mode,
        permissionDenied: permissionDenied,
        notificationsGranted: notifications,
      ),
    );

    _categoriesSub = _categories.watchAll().listen(
      (result) => result.match((_) {}, (categories) => emit(state.copyWith(categories: categories))),
    );
    _recentSub = _imports
        .watchRecent(since: _now().subtract(const Duration(days: days)))
        .listen((result) => result.match((_) {}, (recent) => emit(state.copyWith(recent: recent))));
    _trustSub = _imports.watchTrust().listen((result) => result.match((_) {}, _loadSenders));
  }

  Future<void> _loadSenders(Map<String, bool> trust) async {
    // Without the SMS permission the inbox can't be read; the list then holds
    // only the senders the app already knows from its imports.
    final list = await _listSenders(trust);
    if (isClosed) return;
    list.match((_) {}, (senders) => emit(state.copyWith(senders: senders)));
  }

  /// Re-reads the permissions, after the user came back from the system
  /// settings.
  Future<void> refreshPermissions() async {
    final sms = await _permissions.sms();
    final notifications = await _permissions.notificationsGranted();
    if (isClosed) return;
    emit(
      state.copyWith(
        notificationsGranted: notifications,
        // Granted in the settings: the card goes; the switch stays the user's.
        permissionDenied: state.permissionDenied && sms != SmsPermissionState.granted,
      ),
    );
  }

  /// Turns the feature on after the disclosure was accepted: asks for the SMS
  /// permission, then for notifications. Returns whether it is on now.
  Future<bool> enable() async {
    emit(state.copyWith(enabling: true, permissionDenied: false));
    var sms = await _permissions.sms();
    if (sms != SmsPermissionState.granted) sms = await _permissions.requestSms();
    if (isClosed) return false;
    if (sms != SmsPermissionState.granted) {
      emit(state.copyWith(enabling: false, enabled: false, permissionDenied: true));
      return false;
    }
    var notifications = await _permissions.notificationsGranted();
    if (!notifications) notifications = await _permissions.requestNotifications();
    await _settings.setEnabled(enabled: true);
    if (isClosed) return true;
    emit(state.copyWith(enabling: false, enabled: true, notificationsGranted: notifications));
    unawaited(_loadSenders((await _imports.trusted()).getOrElse((_) => const {})));
    return true;
  }

  /// Turns it off at once; the receiver reads the same preference.
  Future<void> disable() async {
    await _settings.setEnabled(enabled: false);
    if (!isClosed) emit(state.copyWith(enabled: false));
  }

  Future<void> setMode(SmsMode mode) async {
    emit(state.copyWith(mode: mode));
    await _settings.setMode(mode);
  }

  Future<void> openSystemSettings() => _permissions.openSystemSettings();

  /// The switch of a sender in Trusted senders.
  Future<void> setSenderTrusted(SmsSenderEntry sender, {required bool trusted}) async {
    final result = await _actions.setSenderTrusted(sender.key, trusted: trusted);
    if (isClosed) return;
    result.match((failure) => emit(state.copyWith(failure: failure)), (_) {});
  }

  /// "Delete import history": the transactions stay.
  Future<bool> deleteHistory() async {
    final result = await _actions.deleteHistory();
    if (isClosed) return false;
    return result.match((failure) {
      emit(state.copyWith(failure: failure));
      return false;
    }, (_) => true);
  }

  /// Whether the one-time "Import the last 30 days?" sheet is still due.
  Future<bool> catchUpDue() async => !await _settings.catchUpOffered();

  Future<void> markCatchUpOffered() => _settings.markCatchUpOffered();

  // ── Catch-up ──

  /// Scans the inbox and opens the review.
  Future<void> startCatchUp() async {
    emit(state.copyWith(catchUp: const CatchUpState()));
    final result = await _importRecent();
    if (isClosed) return;
    result.match(
      (_) => emit(state.copyWith(catchUp: const CatchUpState(status: CatchUpStatus.failed))),
      (candidates) => emit(
        state.copyWith(
          catchUp: CatchUpState(
            status: CatchUpStatus.ready,
            candidates: candidates,
            // Everything but likely duplicates starts checked.
            selected: {
              for (final candidate in candidates)
                if (!candidate.likelyDuplicate) candidate.smsKey,
            },
          ),
        ),
      ),
    );
  }

  void toggleCandidate(String smsKey) {
    final catchUp = state.catchUp;
    if (catchUp == null || catchUp.status != CatchUpStatus.ready) return;
    final selected = {...catchUp.selected};
    if (!selected.remove(smsKey)) selected.add(smsKey);
    emit(state.copyWith(catchUp: catchUp.copyWith(selected: selected)));
  }

  /// Adds the checked candidates to the default wallet. Returns how many were
  /// added, or null when it failed.
  Future<int?> addSelected() async {
    final catchUp = state.catchUp;
    if (catchUp == null || catchUp.status != CatchUpStatus.ready) return null;
    emit(state.copyWith(catchUp: catchUp.copyWith(status: CatchUpStatus.adding)));
    final result = await _addCatchUp([
      for (final candidate in catchUp.candidates)
        if (catchUp.selected.contains(candidate.smsKey)) candidate,
    ]);
    if (isClosed) return null;
    return result.match(
      (failure) {
        emit(state.copyWith(catchUp: catchUp, failure: failure));
        return null;
      },
      (added) {
        emit(state.copyWith(catchUp: null));
        return added;
      },
    );
  }

  void closeCatchUp() => emit(state.copyWith(catchUp: null));

  @override
  Future<void> close() async {
    await _recentSub?.cancel();
    await _trustSub?.cancel();
    await _categoriesSub?.cancel();
    return super.close();
  }
}
