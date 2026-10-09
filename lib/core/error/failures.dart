import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Why a field failed domain validation. [wrongKind]: the category is of the
/// other kind (expense vs income); [inUse]: a category's kind can't change
/// while transactions use it.
/// Mapped to `validation.*` strings.
enum ValidationReason { required, tooLong, mustBePositive, inFuture, invalidFormat, duplicate, wrongKind, inUse }

/// Every error the data and domain layers return (see Technical Foundation §7).
/// Each case maps to a localized message via `StringManager.failure`; raw
/// exception text never reaches the UI.
@freezed
sealed class Failure with _$Failure {
  /// Domain validation rejected [field] (e.g. `amount`, `title`).
  const factory Failure.validation({
    required String field,
    required ValidationReason reason,
  }) = ValidationFailure;

  /// The entity was deleted between read and write.
  const factory Failure.notFound() = NotFoundFailure;

  /// A DB unique / foreign-key / check constraint was violated.
  const factory Failure.constraint({required String message}) = ConstraintFailure;

  /// Drift / SQLite I/O error, disk full.
  const factory Failure.storage({required String message}) = StorageFailure;

  /// Keychain / Keystore unavailable.
  const factory Failure.secureStorage({required String message}) = SecureStorageFailure;

  /// Writing or sharing an export / backup file failed.
  const factory Failure.exportFailed({required String message}) = ExportFailure;

  const factory Failure.unexpected({
    required Object error,
    StackTrace? stackTrace,
  }) = UnexpectedFailure;
}
