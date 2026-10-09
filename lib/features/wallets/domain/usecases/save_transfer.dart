import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer_draft.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_transfer_repository.dart';
import 'package:masroofy/features/wallets/domain/validation/transfer_validator.dart';

/// Validates and creates (no `id`) or updates a transfer. The note is
/// trimmed, and an empty one is stored as null.
class SaveTransfer {
  SaveTransfer(this._repository, {LocalDate Function()? today}) : _today = today ?? LocalDate.today;

  final ITransferRepository _repository;
  final LocalDate Function() _today;

  /// Returns the transfer id.
  Future<Either<Failure, int>> call(TransferDraft draft, {int? id}) async {
    final note = draft.note?.trim();
    final cleaned = draft.copyWith(note: note == null || note.isEmpty ? null : note);
    final failure = TransferValidator.validate(cleaned, today: _today());
    if (failure != null) return Left(failure);
    if (id == null) return _repository.create(cleaned);
    return (await _repository.update(id, cleaned)).map((_) => id);
  }
}
