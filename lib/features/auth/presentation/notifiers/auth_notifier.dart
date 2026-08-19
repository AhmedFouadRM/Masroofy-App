import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() {
    // true if authenticated, false if locked
    // TODO: Initialize based on auth status
    return true; 
  }

  // TODO: Add methods to lock/unlock
}

final authNotifierProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});
