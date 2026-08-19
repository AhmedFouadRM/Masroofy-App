import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.expensesTitle), // TODO: add this string to StringManager
      ),
      body: const Center(
        child: Text('Expense List Placeholder'), // TODO: Implement body
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add expense screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
