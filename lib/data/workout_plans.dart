import '../models/workout_plan.dart';
import 'workouts.dart';

final List<WorkoutPlan> workoutPlans = [
  WorkoutPlan(
    id: 'wp1',
    name: 'Beginner`s Fitness',
    workouts: {
      'Day 1': workouts[0],
      'Day 2': workouts[1],
      'Day 3': workouts[0],
    },
  ),
  WorkoutPlan(
    id: 'wp2',
    name: 'Strength Builder',
    workouts: {
      'Day 1': workouts[2],
      'Day 2': workouts[3],
      'Day 3': workouts[2],
      'Day 4': workouts[3],
    },
  ),
];
