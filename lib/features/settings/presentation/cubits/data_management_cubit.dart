import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/domain/csv_export.dart';
import 'package:masroofy/features/settings/domain/usecases/clear_all_data.dart';
import 'package:masroofy/features/settings/domain/usecases/export_backup.dart';
import 'package:masroofy/features/settings/domain/usecases/export_expenses_csv.dart';
import 'package:masroofy/features/settings/domain/usecases/pick_backup.dart';
import 'package:masroofy/features/settings/domain/usecases/restore_backup.dart';
import 'package:masroofy/features/settings/presentation/cubits/data_management_state.dart';

export 'package:masroofy/features/settings/presentation/cubits/data_management_state.dart';

/// The Settings → Data actions: export, backup, restore and clear. Each runs
/// one at a time; the screen reacts to [DataManagementState.completed] and
/// [DataManagementState.failure].
class DataManagementCubit extends Cubit<DataManagementState> {
  DataManagementCubit(this._exportCsv, this._exportBackup, this._pickBackup, this._restoreBackup, this._clearAll)
    : super(const DataManagementState());

  final ExportExpensesCsv _exportCsv;
  final ExportBackup _exportBackup;
  final PickBackup _pickBackup;
  final RestoreBackup _restoreBackup;
  final ClearAllData _clearAll;

  Future<void> exportCsv({required Currency currency, required CategoryLabeler categoryLabel}) =>
      _run(DataAction.exportCsv, () => _exportCsv(currency: currency, categoryLabel: categoryLabel));

  Future<void> exportBackup() => _run(DataAction.exportBackup, _exportBackup.call);

  /// Picks and checks a backup file. On success [DataManagementState.pendingRestore]
  /// is set for the screen to confirm; nothing is replaced yet.
  Future<void> pickBackup() async {
    if (state.busy != null) return;
    emit(const DataManagementState(busy: DataAction.restore));
    (await _pickBackup()).match(
      (failure) => emit(DataManagementState(failedAction: DataAction.restore, failure: failure)),
      (picked) => emit(DataManagementState(pendingRestore: picked)),
    );
  }

  void cancelRestore() => emit(const DataManagementState());

  /// Restores the picked backup, after the user confirmed.
  Future<void> confirmRestore() async {
    final picked = state.pendingRestore;
    if (picked == null) return;
    await _run(DataAction.restore, () => _restoreBackup(picked.json));
  }

  Future<void> clearAll() => _run(DataAction.clearAll, _clearAll.call);

  Future<void> _run(DataAction action, Future<Either<Failure, Unit>> Function() operation) async {
    if (state.busy != null) return;
    emit(DataManagementState(busy: action));
    (await operation()).match(
      (failure) => emit(DataManagementState(failedAction: action, failure: failure)),
      (_) => emit(DataManagementState(completed: action)),
    );
  }
}
