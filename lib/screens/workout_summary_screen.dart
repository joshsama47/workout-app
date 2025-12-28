import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/workout_session.dart';

class WorkoutSummaryScreen extends StatelessWidget {
  final WorkoutSession workoutSession;

  const WorkoutSummaryScreen({super.key, required this.workoutSession});

  @override
  Widget build(BuildContext context) {
    final duration = workoutSession.endTime!.difference(
      workoutSession.startTime,
    );
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Summary'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              workoutSession.workoutName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat.yMMMd().add_jm().format(workoutSession.startTime),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Duration', '$minutes:$seconds'),
                _buildStat(
                  'Exercises',
                  workoutSession.exercises.length.toString(),
                ),
                _buildStat('Points', '10'), // Placeholder
              ],
            ),
            const SizedBox(height: 24),
            Text('Exercises', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: workoutSession.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = workoutSession.exercises[index];
                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text('${exercise.sets.length} sets'),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
