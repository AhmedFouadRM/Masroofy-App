import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';

/// A pot of transactions ("Me", "Wife", "Son"). The default wallet "Me" has a
/// [seedKey] (its name comes from the translation files); every other wallet
/// has a user-typed [name]. Exactly one is set. Resolving the display name
/// needs translations, so it lives in presentation.
///
/// Which wallet is the default one is a preference, not part of the wallet.
@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    required int id,
    required String icon,
    required int color,
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? seedKey,
    String? name,
  }) = _Wallet;

  const Wallet._();

  bool get isSeeded => seedKey != null;
}
