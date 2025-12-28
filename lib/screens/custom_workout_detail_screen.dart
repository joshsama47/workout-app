import 'package:flutter/material.dart';
import 'package:myapp/models/custom_workout_model.dart';

class CustomWorkoutDetailScreen extends StatelessWidget {
  final CustomWorkout workout;

  const CustomWorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workout.name)),
      body: ListView.builder(
        itemCount: workout.exercises.length,
        itemBuilder: (context, index) {
          final exercise = workout.exercises[index];
          return ListTile(title: Text(exercise.name));
        },
      ),
    );
  }
}
