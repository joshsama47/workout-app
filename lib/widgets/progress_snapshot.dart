import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/progress_service.dart';

class ProgressSnapshot extends StatelessWidget {
  const ProgressSnapshot({super.key});

  @override
  Widget build(BuildContext context) {
    final progressService = Provider.of<ProgressService>(context);

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
                _buildStat(context, 'Streak', '${progressService.streak} days'),
                _buildStat(
                  context,
                  'This Week',
                  '${progressService.weeklyWorkoutCount} workouts',
                ),
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
