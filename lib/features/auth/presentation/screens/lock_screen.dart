import 'package:flutter/material.dart';

class LockScreen extends StatelessWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter PIN'),
            // TODO: Implement PIN pad
            ElevatedButton(
              onPressed: () {
                // TODO: verify PIN
              },
              child: const Text('Unlock'),
            ),
          ],
        ),
      ),
    );
  }
}
