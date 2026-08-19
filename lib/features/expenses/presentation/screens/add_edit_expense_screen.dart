import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';

class AddEditExpenseScreen extends StatefulWidget {
  const AddEditExpenseScreen({super.key});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  // TODO: Add form keys and controllers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.addExpense), // TODO: add this string to StringManager
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            // TODO: Implement title field
            // TODO: Implement amount field
            // TODO: Implement category picker
            // TODO: Implement date picker
            // TODO: Implement note field
            Text('Form placeholders'),
          ],
        ),
      ),
    );
  }
}
