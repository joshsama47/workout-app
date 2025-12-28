import 'exercise.dart';

class Workout {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final int sets;
  final int reps;
  final int rest;
  final int duration;
  final DateTime? completedAt;

  Workout({
    required this.id,
    required this.name,
    required this.exercises,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.duration,
    this.completedAt,
  });

  Workout copyWith({
    String? id,
    String? name,
    List<Exercise>? exercises,
    int? sets,
    int? reps,
    int? rest,
    int? duration,
    DateTime? completedAt,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      exercises: exercises ?? this.exercises,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      rest: rest ?? this.rest,
      duration: duration ?? this.duration,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
