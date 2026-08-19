import 'package:flutter/material.dart';

class DailyBarChart extends StatelessWidget {
  const DailyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: const Center(
        child: Text('Bar Chart Placeholder'), // TODO: Implement using fl_chart
      ),
    );
  }
}
