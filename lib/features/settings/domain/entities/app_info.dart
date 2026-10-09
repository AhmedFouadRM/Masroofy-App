import 'package:meta/meta.dart';

/// The installed app's version, shown in Settings → About.
@immutable
final class AppInfo {
  const AppInfo({required this.version, required this.buildNumber});

  final String version;
  final String buildNumber;

  /// `1.0.0 (1)`.
  String get label => buildNumber.isEmpty ? version : '$version ($buildNumber)';
}
