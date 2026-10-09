import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/strings/string_manager.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.settingsTitle), // TODO: add string
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Currency'),
            onTap: () {
              // TODO: Implement currency change
            },
          ),
          ListTile(
            title: const Text('Language'),
            onTap: () {
              // TODO: Implement language change
            },
          ),
          ListTile(
            title: const Text('Theme'),
            onTap: () {
              // TODO: Implement theme change
            },
          ),
          ListTile(
            title: const Text('App Lock'),
            onTap: () {
              // TODO: Implement app lock settings
            },
          ),
          ListTile(
            title: Text(StringManager.manageCategories),
            onTap: () => context.push(RoutePaths.categories),
          ),
          ListTile(
            title: Text(StringManager.manageBudgets),
            onTap: () => context.push(RoutePaths.budgets),
          ),
          ListTile(
            title: const Text('Export Data'),
            onTap: () {
              // TODO: Implement export
            },
          ),
          ListTile(
            title: const Text('Clear Data'),
            onTap: () {
              // TODO: Implement clear data
            },
          ),
          const ListTile(
            title: Text('Version'),
            subtitle: Text('1.0.0'), // TODO: Get dynamically
          ),
        ],
      ),
    );
  }
}
