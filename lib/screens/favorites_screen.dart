import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workout_provider.dart';
import '../widgets/workout_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final favoriteWorkouts = workoutProvider.favoriteWorkouts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Workouts'),
      ),
      body: favoriteWorkouts.isEmpty
          ? const Center(
              child: Text('You have no favorite workouts yet.'),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteWorkouts.length,
              itemBuilder: (context, index) {
                final workout = favoriteWorkouts[index];
                return WorkoutCard(workout: workout);
              },
            ),
    );
  }
}
