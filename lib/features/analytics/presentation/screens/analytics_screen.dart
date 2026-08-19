import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/features/analytics/presentation/widgets/spending_pie_chart.dart';
import 'package:masroofy/features/analytics/presentation/widgets/daily_bar_chart.dart';
import 'package:masroofy/features/analytics/presentation/widgets/budget_progress_bar.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.analyticsTitle), // TODO: add string
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text('Spending by Category'),
          SpendingPieChart(),
          SizedBox(height: 16),
          Text('Daily Spending'),
          DailyBarChart(),
          SizedBox(height: 16),
          Text('Budget Progress'),
          BudgetProgressBar(),
        ],
      ),
    );
  }
}
