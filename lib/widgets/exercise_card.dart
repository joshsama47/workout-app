import 'package:flutter/material.dart';

import '../models/exercise.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(exercise.name),
        subtitle: Text(exercise.description),
        trailing: Text('${exercise.sets}x${exercise.reps}'),
      ),
    );
  }
}
