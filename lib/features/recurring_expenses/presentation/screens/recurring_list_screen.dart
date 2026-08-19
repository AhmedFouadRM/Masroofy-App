import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';

class RecurringListScreen extends StatelessWidget {
  const RecurringListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.recurringTitle), // TODO: add string
      ),
      body: const Center(
        child: Text('Recurring Expenses Placeholder'), // TODO: Implement body
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add recurring expense
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
