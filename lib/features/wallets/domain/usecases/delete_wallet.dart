import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';

/// Deletes a wallet, moving its transactions and templates to `moveTo`. The
/// caller makes another wallet the default first when the default one goes.
class DeleteWallet {
  DeleteWallet(this._repository);

  final IWalletRepository _repository;

  Future<Either<Failure, Unit>> call(int id, {int? moveTo}) {
    if (moveTo == id) {
      return Future.value(const Left(ValidationFailure(field: 'moveTo', reason: ValidationReason.invalidFormat)));
    }
    return _repository.delete(id, moveTo: moveTo);
  }
}
