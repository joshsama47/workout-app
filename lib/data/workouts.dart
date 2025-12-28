import '../models/workout.dart';
import 'exercises.dart';

final List<Workout> workouts = [
  Workout(
    id: 'w1',
    name: 'Full Body Blast',
    exercises: [allExercises[0], allExercises[1], allExercises[2]],
    sets: 3,
    reps: 12,
    rest: 60,
    duration: 30,
  ),
  Workout(
    id: 'w2',
    name: 'Core Crusher',
    exercises: [allExercises[4], allExercises[3]],
    sets: 4,
    reps: 15,
    rest: 45,
    duration: 20,
  ),
  Workout(
    id: 'w3',
    name: 'Upper Body Burn',
    exercises: [allExercises[0]],
    sets: 5,
    reps: 10,
    rest: 60,
    duration: 25,
  ),
  Workout(
    id: 'w4',
    name: 'Lower Body Blitz',
    exercises: [allExercises[1]],
    sets: 5,
    reps: 10,
    rest: 60,
    duration: 25,
  ),
];
