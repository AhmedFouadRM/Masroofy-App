import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/domain/entities/backup_preview.dart';

part 'data_management_state.freezed.dart';

enum DataAction { exportCsv, exportBackup, restore, clearAll }

@freezed
abstract class DataManagementState with _$DataManagementState {
  const factory DataManagementState({
    /// The action in progress; further taps are ignored meanwhile.
    DataAction? busy,

    /// A backup that was picked and checked, awaiting the user's confirmation.
    PickedBackup? pendingRestore,

    /// The action that just finished; reset when the next one starts, so the
    /// screen's listener sees every completion.
    DataAction? completed,

    /// The action that just failed, and why.
    DataAction? failedAction,
    Failure? failure,
  }) = _DataManagementState;
}
