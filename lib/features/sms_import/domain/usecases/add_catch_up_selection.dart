import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';
import 'package:masroofy/features/sms_import/domain/entities/catch_up_candidate.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_settings.dart';

/// Adds the candidates the user checked in the catch-up review to the default
/// wallet, whatever the mode is. Each becomes an import (so it is never added
/// twice) and a transaction with `source = sms`.
class AddCatchUpSelection {
  AddCatchUpSelection({
    required this._settings,
    required this._imports,
    required this._saveExpense,
    LocalDate Function()? today,
  }) : _today = today ?? LocalDate.today;

  final ISmsSettings _settings;
  final ISmsImportRepository _imports;
  final SaveExpense _saveExpense;
  final LocalDate Function() _today;

  /// Returns how many were added. One that fails is skipped, not retried.
  Future<Either<Failure, int>> call(List<CatchUpCandidate> selected) async {
    final settings = await _settings.load();
    final walletId = settings.defaultWalletId;
    if (walletId == null) return const Left(Failure.notFound());

    var added = 0;
    for (final candidate in selected) {
      final parsed = candidate.parsed;
      final date = parsed.date.isAfter(_today()) ? _today() : parsed.date;
      final inserted = await _imports.insert(
        SmsImportDraft(
          smsKey: candidate.smsKey,
          sender: candidate.sender,
          receivedAt: candidate.receivedAt,
          kind: parsed.kind.transactionKind,
          amount: parsed.amount,
          currency: parsed.currency,
          date: date,
          merchant: parsed.merchant,
          categoryId: candidate.categoryId,
          cardLast4: parsed.cardLast4,
          note: parsed.note.isEmpty ? null : parsed.note,
        ),
      );
      final import = inserted.toNullable();
      if (import == null) continue;
      final saved = await _saveExpense(
        ExpenseDraft(
          amount: parsed.amount,
          walletId: walletId,
          categoryId: candidate.categoryId,
          date: date,
          title: parsed.merchant,
          note: parsed.note,
          kind: parsed.kind.transactionKind,
          source: ExpenseSource.sms,
        ),
      );
      final expenseId = saved.toNullable();
      if (expenseId == null) {
        // Leave nothing half-done: the user can scan again.
        await _imports.deleteImport(import.id);
        continue;
      }
      await _imports.setStatus(import.id, SmsImportStatus.added, expenseId: expenseId);
      added++;
    }
    return Right(added);
  }
}
