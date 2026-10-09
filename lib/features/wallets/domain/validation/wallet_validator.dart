import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_draft.dart';
import 'package:masroofy/features/wallets/domain/wallet_icons.dart';

/// Field rules from the Wallets PRD → Validation Rules.
abstract final class WalletValidator {
  /// Compares names case-insensitively, ignoring surrounding and repeated
  /// whitespace ("  My  Son " == "my son").
  static String normalize(String name) => name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();

  /// Returns the first failing rule, or `null` when [draft] is valid.
  /// [takenNames] holds the other custom wallets' names; they are normalized
  /// here. A null [WalletDraft.name] (keep the seeded name) is only valid
  /// when [keepsSeedName] says the wallet being edited is seeded.
  static ValidationFailure? validate(
    WalletDraft draft, {
    required Iterable<String> takenNames,
    required bool keepsSeedName,
  }) {
    final raw = draft.name;
    if (raw == null && !keepsSeedName) {
      return const ValidationFailure(field: 'name', reason: ValidationReason.required);
    }
    if (raw != null) {
      final name = normalize(raw);
      if (name.isEmpty) {
        return const ValidationFailure(field: 'name', reason: ValidationReason.required);
      }
      if (name.length > AppConstants.maxWalletNameLength) {
        return const ValidationFailure(field: 'name', reason: ValidationReason.tooLong);
      }
      if (takenNames.map(normalize).contains(name)) {
        return const ValidationFailure(field: 'name', reason: ValidationReason.duplicate);
      }
    }
    if (!WalletIcons.keys.contains(draft.icon)) {
      return const ValidationFailure(field: 'icon', reason: ValidationReason.invalidFormat);
    }
    return null;
  }
}
