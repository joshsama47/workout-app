import 'workout.dart';

class WorkoutPlan {
  final String id;
  final String name;
  final Map<String, Workout> workouts;

  WorkoutPlan({
    required this.id,
    required this.name,
    required this.workouts,
  });
}
