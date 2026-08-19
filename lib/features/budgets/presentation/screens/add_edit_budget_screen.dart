import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';

class AddEditBudgetScreen extends StatefulWidget {
  const AddEditBudgetScreen({super.key});

  @override
  State<AddEditBudgetScreen> createState() => _AddEditBudgetScreenState();
}

class _AddEditBudgetScreenState extends State<AddEditBudgetScreen> {
  // TODO: Add form keys and controllers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.addBudget), // TODO: add string
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            // TODO: Implement fields
            Text('Form placeholders'),
          ],
        ),
      ),
    );
  }
}
