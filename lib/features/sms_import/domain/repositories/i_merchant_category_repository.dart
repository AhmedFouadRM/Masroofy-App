import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';

/// The category the user chose for a merchant, and the default categories.
abstract interface class IMerchantCategoryRepository {
  /// The learned category of [merchantKey], when it is of [kind].
  Future<Either<Failure, int?>> learnedCategory(String merchantKey, TransactionKind kind);

  /// The id of the default category with [seedKey], or null when it is gone.
  Future<Either<Failure, int?>> categoryIdBySeedKey(String seedKey);

  /// Remembers [categoryId] for [merchantKey], replacing an earlier choice.
  Future<Either<Failure, Unit>> learn(String merchantKey, int categoryId);
}
