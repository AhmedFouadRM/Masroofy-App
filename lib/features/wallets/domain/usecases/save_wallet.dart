import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_draft.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';
import 'package:masroofy/features/wallets/domain/validation/wallet_validator.dart';

/// Validates and creates (no `id`) or updates a wallet. The stored name is
/// trimmed with inner whitespace collapsed, but keeps its casing.
class SaveWallet {
  SaveWallet(this._repository);

  final IWalletRepository _repository;

  /// Returns the wallet id.
  Future<Either<Failure, int>> call(WalletDraft draft, {int? id}) async {
    final taken = await _repository.customNames(excludeId: id);
    return taken.match(Left.new, (takenNames) async {
      var keepsSeedName = false;
      if (id != null) {
        final existing = await _repository.getById(id);
        switch (existing) {
          case Left(:final value):
            return Left(value);
          case Right(:final value):
            keepsSeedName = value.isSeeded;
        }
      }
      final failure = WalletValidator.validate(draft, takenNames: takenNames, keepsSeedName: keepsSeedName);
      if (failure != null) return Left(failure);

      final name = draft.name;
      final cleaned = name == null ? draft : draft.copyWith(name: name.trim().replaceAll(RegExp(r'\s+'), ' '));
      if (id == null) return _repository.create(cleaned);
      return (await _repository.update(id, cleaned)).map((_) => id);
    });
  }
}
