import 'exercise.dart';

class Workout {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final int sets;
  final int reps;
  final int rest;

  Workout({
    required this.id,
    required this.name,
    required this.exercises,
    required this.sets,
    required this.reps,
    required this.rest,
  });
}
