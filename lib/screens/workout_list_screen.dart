import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/workout_plans.dart';
import '../main.dart';

class WorkoutListScreen extends StatelessWidget {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = workoutPlans;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Card(
            margin: const EdgeInsets.all(12.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(plan.name, style: Theme.of(context).textTheme.headline6),
              subtitle: Text('${plan.workouts.length} workouts'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/plan/${plan.id}');
              },
            ),
          );
        },
      ),
    );
  }
}
