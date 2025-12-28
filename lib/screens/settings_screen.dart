import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../providers/workout_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: Provider.of<UserProvider>(context, listen: false).user?.name ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).setUserName(_nameController.text);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Name saved!')));
              },
              child: const Text('Save Name'),
            ),
            const Divider(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/body-composition'),
              child: const Text('Body Composition'),
            ),
            const Divider(height: 40),
            ElevatedButton(
              onPressed: () {
                Provider.of<WorkoutManager>(
                  context,
                  listen: false,
                ).clearWorkouts();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All workout data cleared!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Clear All Workout Data'),
            ),
          ],
        ),
      ),
    );
  }
}
