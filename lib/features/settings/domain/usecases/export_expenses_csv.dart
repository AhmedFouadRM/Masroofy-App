import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/domain/csv_export.dart';
import 'package:masroofy/features/settings/domain/entities/expense_export_row.dart';
import 'package:masroofy/features/settings/domain/repositories/i_data_management_repository.dart';
import 'package:masroofy/features/settings/domain/repositories/i_file_services.dart';

/// Builds `masroofix_expenses_YYYY-MM-DD.csv` and opens the share sheet.
class ExportExpensesCsv {
  ExportExpensesCsv(this._repository, this._sharer, {LocalDate Function()? today}) : _today = today ?? LocalDate.today;

  final IDataManagementRepository _repository;
  final IFileSharer _sharer;
  final LocalDate Function() _today;

  /// Above this many records the text is encoded off the UI isolate.
  static const isolateThreshold = 5000;

  Future<Either<Failure, Unit>> call({
    required Currency currency,
    required CategoryLabeler categoryLabel,
    required WalletLabeler walletLabel,
  }) async {
    final loaded = await _repository.loadExpenseExport();
    return loaded.match(
      (failure) async => Left(failure),
      (expenses) => _share(expenses, currency, categoryLabel, walletLabel),
    );
  }

  Future<Either<Failure, Unit>> _share(
    List<ExpenseExportRow> expenses,
    Currency currency,
    CategoryLabeler categoryLabel,
    WalletLabeler walletLabel,
  ) async {
    try {
      // Category and wallet names come from the translations, which only exist
      // on this isolate, so the records are built here and only the encoding moves.
      final records = CsvExport.records(expenses, currency, categoryLabel, walletLabel);
      final text = records.length > isolateThreshold
          ? await Isolate.run(() => CsvExport.encode(records))
          : CsvExport.encode(records);
      return _sharer.share(
        fileName: 'masroofix_expenses_${_today().toIso()}.csv',
        bytes: Uint8List.fromList([...CsvExport.bom, ...utf8.encode(text)]),
        mimeType: 'text/csv',
      );
    } on Object catch (error) {
      return Left(Failure.exportFailed(message: '$error'));
    }
  }
}
