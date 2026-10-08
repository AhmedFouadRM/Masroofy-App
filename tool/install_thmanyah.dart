// Copies the licensed Thmanyah Sans files into assets/fonts/thmanyah/.
// They are gitignored: the licence forbids redistributing them.
//
//   dart run tool/install_thmanyah.dart "<folder with thmanyahsans-*.otf>"
// ignore_for_file: avoid_print

import 'dart:io';

const _weights = ['Regular', 'Medium', 'Bold'];

void main(List<String> args) {
  if (args.length != 1) {
    print('Usage: dart run tool/install_thmanyah.dart <source folder>');
    exit(64);
  }
  final target = Directory('assets/fonts/thmanyah')..createSync(recursive: true);
  for (final weight in _weights) {
    final source = File('${args.single}/thmanyahsans-$weight.otf');
    if (!source.existsSync()) {
      print('Missing ${source.path}');
      exit(66);
    }
    source.copySync('${target.path}/thmanyahsans-$weight.otf');
    print('Copied thmanyahsans-$weight.otf');
  }
}
