import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.categoriesTitle), // TODO: add string
      ),
      body: const Center(
        child: Text('Category List Placeholder'), // TODO: Implement body
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add category
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
