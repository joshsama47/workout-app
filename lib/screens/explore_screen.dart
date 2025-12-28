import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/custom_workout_provider.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: ListView(
        children: [
          _buildExploreCard(
            context,
            icon: Icons.movie,
            title: 'On-Demand Classes',
            onTap: () => context.go('/on-demand-classes'),
          ),
          _buildExploreCard(
            context,
            icon: Icons.emoji_events,
            title: 'Challenges',
            onTap: () => context.go('/challenges'),
          ),
          _buildExploreCard(
            context,
            icon: Icons.group,
            title: 'Social Events',
            onTap: () => context.go('/social-events'),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Custom Workouts',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<CustomWorkoutProvider>(
            builder: (context, provider, child) {
              if (provider.customWorkouts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'You haven\'t created any custom workouts yet. Get started by tapping the + button below!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.customWorkouts.length,
                itemBuilder: (context, index) {
                  final workout = provider.customWorkouts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(workout.name),
                      subtitle: Text('${workout.exercises.length} exercises'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        context.go('/custom-workout-detail', extra: workout);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/custom-workout-builder');
        },
        label: const Text('Create Workout'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildExploreCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
