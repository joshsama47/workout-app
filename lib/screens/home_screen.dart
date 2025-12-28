import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../data/workout_plans.dart';
import '../models/workout.dart';
import '../providers/user_provider.dart';
import '../widgets/progress_snapshot.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final todayWorkout = workoutPlans.first.workouts.values.first;

    return Scaffold(
      appBar: AppBar(
        title: Text('Good Morning, ${user?.name ?? 'User'}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const ProgressSnapshot(),
          const SizedBox(height: 24),
          _buildTodaysPlanCard(context, todayWorkout),
          const SizedBox(height: 24),
          _buildOutdoorWorkoutCard(context),
          const SizedBox(height: 24),
          _buildCommunityFeed(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement quick actions
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodaysPlanCard(BuildContext context, Workout workout) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.go('/workout/${workout.id}/in-progress');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Plan',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.fitness_center, size: 40),
                title: Text(
                  workout.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text('${workout.duration} minutes'),
                trailing: const Icon(Icons.play_arrow_rounded, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutdoorWorkoutCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          context.go('/outdoor-workout');
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Track Your Activity',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.directions_run, size: 40),
                title: Text(
                  'Start Outdoor Workout',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: const Text('Track your run, walk, or bike ride'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunityFeed(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Community Activity',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.go('/leaderboard'),
              child: const Text('View Leaderboard'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCommunityFeedItem(
          context,
          'Alice',
          'completed the \'Cardio Burn\' workout',
          '2 hours ago',
        ),
        _buildCommunityFeedItem(
          context,
          'Bob',
          'shared a new custom workout: \'Leg Day Annihilator\'',
          '8 hours ago',
        ),
        _buildCommunityFeedItem(
          context,
          'Charlie',
          'achieved a new personal record in deadlifts!',
          '1 day ago',
        ),
      ],
    );
  }

  Widget _buildCommunityFeedItem(
    BuildContext context,
    String name,
    String activity,
    String time,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(name[0])),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(time, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(activity, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.thumb_up_alt_outlined, size: 18),
                  label: const Text('Like'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
