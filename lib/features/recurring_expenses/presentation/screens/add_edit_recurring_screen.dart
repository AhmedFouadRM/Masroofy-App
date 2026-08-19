import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';

class AddEditRecurringScreen extends StatefulWidget {
  const AddEditRecurringScreen({super.key});

  @override
  State<AddEditRecurringScreen> createState() => _AddEditRecurringScreenState();
}

class _AddEditRecurringScreenState extends State<AddEditRecurringScreen> {
  // TODO: Add form keys and controllers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.addRecurring), // TODO: add string
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
