import 'dart:async';

import 'package:flutter/foundation.dart';

/// A [Listenable] that fires whenever any of `streams` emits, to re-run the
/// router redirect when a cubit's state changes (`GoRouter.refreshListenable`).
class StreamsListenable extends ChangeNotifier {
  StreamsListenable(Iterable<Stream<Object?>> streams) {
    for (final stream in streams) {
      _subscriptions.add(stream.listen((_) => notifyListeners()));
    }
  }

  final _subscriptions = <StreamSubscription<Object?>>[];

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }
}
