import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/domain/catalog/merchants.dart';
import 'package:masroofy/features/sms_import/domain/merchant_key.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_merchant_category_repository.dart';

/// Picks the category of a transaction from an SMS: the one the user chose
/// for this merchant before, else the built-in keyword list, else **Other**
/// (**Other income** for income).
class ResolveCategory {
  ResolveCategory(this._repository);

  final IMerchantCategoryRepository _repository;

  // Seed keys of the default fallback categories (`DefaultCategories`).
  static const _otherSeedKey = 'other';
  static const _otherIncomeSeedKey = 'other_income';

  /// The category id. Fails with `NotFoundFailure` only when even the
  /// fallback category is gone.
  Future<Either<Failure, int>> call(String? merchant, TransactionKind kind) async {
    final key = MerchantKey.of(merchant);
    if (key != null) {
      final learned = (await _repository.learnedCategory(key, kind)).toOption().flatMap(Option.fromNullable);
      if (learned case Some(:final value)) return Right(value);

      final seedKey = keywordSeedKey(key, kind);
      if (seedKey != null) {
        final byKeyword = (await _repository.categoryIdBySeedKey(seedKey)).toOption().flatMap(Option.fromNullable);
        if (byKeyword case Some(:final value)) return Right(value);
      }
    }
    final fallback = kind == TransactionKind.income ? _otherIncomeSeedKey : _otherSeedKey;
    return (await _repository.categoryIdBySeedKey(fallback)).flatMap(
      (id) => id == null ? const Left(Failure.notFound()) : Right(id),
    );
  }

  /// The built-in category for a normalised merchant name, or null.
  static String? keywordSeedKey(String merchantKey, TransactionKind kind) {
    final rules = kind == TransactionKind.income ? MerchantCatalog.incomeRules : MerchantCatalog.expenseRules;
    final tokens = merchantKey.split(' ');
    final padded = ' $merchantKey ';
    for (final rule in rules) {
      for (final keyword in rule.keywords) {
        if (_matches(keyword, tokens, padded, merchantKey)) return rule.seedKey;
      }
    }
    return null;
  }

  static final _arabic = RegExp(r'[\u0600-\u06FF]');

  static bool _matches(String keyword, List<String> tokens, String padded, String key) {
    // Arabic has no word boundaries to rely on; a few letters match anywhere.
    if (_arabic.hasMatch(keyword)) return key.contains(keyword);
    if (keyword.contains(' ')) return padded.contains(' $keyword ');
    return tokens.any((token) => token == keyword || (keyword.length >= 5 && token.startsWith(keyword)));
  }
}
