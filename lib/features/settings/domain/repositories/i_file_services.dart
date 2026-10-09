import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';

/// Hands a generated file to the OS share sheet.
// ignore: one_member_abstracts
abstract interface class IFileSharer {
  /// Writes [bytes] to a temporary file called [fileName] and shares it.
  /// Fails with an [ExportFailure].
  Future<Either<Failure, Unit>> share({required String fileName, required Uint8List bytes, required String mimeType});
}

/// Lets the user pick a backup file.
// ignore: one_member_abstracts
abstract interface class IBackupFilePicker {
  /// The picked file's text, or null when the user cancelled.
  Future<Either<Failure, String?>> pickBackupText();
}
