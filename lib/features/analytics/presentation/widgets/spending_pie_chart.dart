import 'package:flutter/material.dart';

class SpendingPieChart extends StatelessWidget {
  const SpendingPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: const Center(
        child: Text('Pie Chart Placeholder'), // TODO: Implement using fl_chart
      ),
    );
  }
}
