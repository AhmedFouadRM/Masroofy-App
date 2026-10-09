import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/sms_import/domain/entities/catch_up_candidate.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_sender_entry.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';

part 'sms_import_state.freezed.dart';

enum CatchUpStatus {
  /// Reading the inbox.
  scanning,

  /// The review list is ready.
  ready,

  /// Adding the selected ones.
  adding,

  /// The inbox could not be read.
  failed,
}

/// The catch-up review: the candidates found in the last 30 days and the ones
/// checked.
@freezed
abstract class CatchUpState with _$CatchUpState {
  const factory CatchUpState({
    @Default(CatchUpStatus.scanning) CatchUpStatus status,
    @Default(<CatchUpCandidate>[]) List<CatchUpCandidate> candidates,

    /// The `smsKey`s of the checked candidates.
    @Default(<String>{}) Set<String> selected,
  }) = _CatchUpState;

  const CatchUpState._();

  int get selectedCount => selected.length;
}

@freezed
abstract class SmsImportState with _$SmsImportState {
  const factory SmsImportState({
    /// Until the settings and permission have been read.
    @Default(true) bool loading,

    /// The switch. False whenever the SMS permission is missing.
    @Default(false) bool enabled,
    @Default(SmsMode.ask) SmsMode mode,

    /// The user said no to the SMS permission; shows the Open settings card.
    @Default(false) bool permissionDenied,

    /// Ask mode needs notifications.
    @Default(true) bool notificationsGranted,

    /// Waiting for the permission prompts.
    @Default(false) bool enabling,
    @Default(<SmsSenderEntry>[]) List<SmsSenderEntry> senders,

    /// The imports of the last 30 days, newest first.
    @Default(<SmsImport>[]) List<SmsImport> recent,
    @Default(<Category>[]) List<Category> categories,

    /// The catch-up review while its sheet is open.
    CatchUpState? catchUp,
    Failure? failure,
  }) = _SmsImportState;

  const SmsImportState._();

  /// Ask mode is on but notifications are off, so nothing can ask.
  bool get notificationsBlocked => enabled && mode == SmsMode.ask && !notificationsGranted;

  Category? category(int? id) => categories.where((c) => c.id == id).firstOrNull;
}
