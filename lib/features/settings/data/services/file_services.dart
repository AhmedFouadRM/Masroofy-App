import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/settings/domain/repositories/i_file_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Writes the file to the temp directory and opens the OS share sheet.
class ShareFileService implements IFileSharer {
  @override
  Future<Either<Failure, Unit>> share({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}${Platform.pathSeparator}$fileName');
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: mimeType)]));
      return const Right(unit);
    } on Object catch (error) {
      return Left(Failure.exportFailed(message: '$error'));
    }
  }
}

/// Picks a `.json` file with the OS file picker and reads it as text.
class BackupFilePickerService implements IBackupFilePicker {
  /// A backup of years of daily expenses is a few MB; anything this big is
  /// not one, and decoding it would only stall the app.
  static const int maxBytes = 50 * 1024 * 1024;

  static const _invalidBackup = Failure.validation(field: 'backup', reason: ValidationReason.invalidFormat);

  @override
  Future<Either<Failure, String?>> pickBackupText() async {
    try {
      final file = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: const ['json']);
      if (file == null) return const Right(null);
      final size = file.lengthSync() ?? await file.length();
      if (size == null || size > maxBytes) return const Left(_invalidBackup);
      return Right(utf8.decode(await file.readAsBytes()));
    } on FormatException {
      // Not UTF-8 text.
      return const Left(_invalidBackup);
    } on Object catch (error) {
      return Left(Failure.storage(message: '$error'));
    }
  }
}
