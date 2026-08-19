import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';

class BudgetListScreen extends StatelessWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.budgetsTitle), // TODO: add string
      ),
      body: const Center(
        child: Text('Budgets Placeholder'), // TODO: Implement body
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add budget
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
