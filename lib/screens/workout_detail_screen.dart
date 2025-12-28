import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../models/workout.dart';
import '../services/notification_service.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  Future<void> _setReminder(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (!mounted || !context.mounted) return;

    if (pickedTime != null) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      NotificationService.scheduleNotification(
        'Workout Reminder',
        'Time for your ${widget.workout.name} workout!',
        scheduledTime,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reminder set!')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No reminder set.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final workoutDetails =
                  'Check out this workout: ${widget.workout.name ?? ''}\n\n'
                  'Sets: ${widget.workout.sets}\n'
                  'Reps: ${widget.workout.reps}\n'
                  'Rest: ${widget.workout.rest} seconds\n\n'
                  'Exercises:\n${widget.workout.exercises.map((e) => '- ${e.name}').join('\n')}';
              SharePlus.instance.share(
                ShareParams(
                  text: workoutDetails,
                  subject: 'Workout Plan: ${widget.workout.name ?? ''}',
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sets: ${widget.workout.sets}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reps: ${widget.workout.reps}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rest: ${widget.workout.rest} seconds',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.workout.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.workout.exercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(exercise.description ?? "no description"),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  context.go('/workout/${widget.workout.id}/in-progress'),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Workout'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _setReminder(context),
              icon: const Icon(Icons.notifications),
              label: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
