import 'package:flutter/material.dart';

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.grey[200],
      child: const Center(
        child: Text('Budget Progress Placeholder'), // TODO: Implement linear progress indicator
      ),
    );
  }
}
