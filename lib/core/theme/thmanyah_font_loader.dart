import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Registers Thmanyah Sans at runtime from `assets/fonts/thmanyah/` when the
/// files are installed (they are gitignored; see `tool/install_thmanyah.dart`).
/// When they are absent, Arabic text falls back to the system font, so builds
/// from the public repo still work.
abstract final class ThmanyahFontLoader {
  static const family = 'Thmanyah';
  static const _folder = 'assets/fonts/thmanyah/';

  /// Returns whether the font was found and loaded.
  static Future<bool> load([AssetBundle? bundle]) async {
    final assets = bundle ?? rootBundle;
    final manifest = await AssetManifest.loadFromAssetBundle(assets);
    final files = manifest.listAssets().where((path) => path.startsWith(_folder) && path.endsWith('.otf')).toList();
    if (files.isEmpty) {
      debugPrint('Thmanyah Sans not installed; Arabic uses the system font.');
      return false;
    }
    // The engine reads each file's weight from its OS/2 table.
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(assets.load(file));
    }
    await loader.load();
    return true;
  }
}
