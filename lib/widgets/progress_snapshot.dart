import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/workout_service.dart';

class ProgressSnapshot extends StatelessWidget {
  const ProgressSnapshot({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutService = Provider.of<WorkoutService>(context);
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FutureBuilder<int>(
                  future: workoutService.getWorkoutStreak(user.uid),
                  builder: (context, snapshot) {
                    final streak = snapshot.data ?? 0;
                    return _buildStat(context, 'Streak', '$streak days');
                  },
                ),
                StreamBuilder(
                    stream: workoutService.getWorkoutHistory(user.uid),
                    builder: (context, snapshot) {
                      final weeklyWorkoutCount = snapshot.data?.length ?? 0;
                      return _buildStat(
                        context,
                        'This Week',
                        '$weeklyWorkoutCount workouts',
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
