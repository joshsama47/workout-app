import '../models/workout.dart';
import 'exercises.dart';

final List<Workout> workouts = [
  Workout(
    id: 'w1',
    name: 'Full Body Blast',
    exercises: [exercises[0], exercises[1], exercises[2]],
    sets: 3,
    reps: 12,
    rest: 60,
  ),
  Workout(
    id: 'w2',
    name: 'Core Crusher',
    exercises: [exercises[4], exercises[3]],
    sets: 4,
    reps: 15,
    rest: 45,
  ),
  Workout(
    id: 'w3',
    name: 'Upper Body Burn',
    exercises: [exercises[0]],
    sets: 5,
    reps: 10,
    rest: 60,
  ),
  Workout(
    id: 'w4',
    name: 'Lower Body Blitz',
    exercises: [exercises[1]],
    sets: 5,
    reps: 10,
    rest: 60,
  ),
];
