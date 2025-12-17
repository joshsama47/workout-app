import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/workout_plan.dart';
import '../widgets/workout_card.dart';

class WorkoutPlanDetailScreen extends StatelessWidget {
  final WorkoutPlan plan;

  const WorkoutPlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.name),
      ),
      body: ListView.builder(
        itemCount: plan.workouts.length,
        itemBuilder: (context, index) {
          final day = plan.workouts.keys.elementAt(index);
          final workout = plan.workouts[day]!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(day, style: Theme.of(context).textTheme.headline6),
              subtitle: Text(workout.name),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/workout/${workout.id}');
              },
            ),
          );
        },
      ),
    );
  }
}
