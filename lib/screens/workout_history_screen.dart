import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/workout_session.dart';
import 'package:myapp/screens/workout_summary_screen.dart';
import 'package:provider/provider.dart';

import '../services/progress_service.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressService = Provider.of<ProgressService>(context);
    final completedWorkouts = progressService.completedWorkouts;

    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: completedWorkouts.isEmpty
          ? const Center(
              child: Text(
                'No workouts completed yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: completedWorkouts.length,
              itemBuilder: (context, index) {
                final workout = completedWorkouts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.fitness_center,
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      workout.workoutName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Completed on ${DateFormat.yMMMd().format(workout.endTime!)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WorkoutSummaryScreen(workoutSession: workout),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
