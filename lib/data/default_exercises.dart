import 'package:myapp/models/exercise.dart';
import 'package:myapp/models/personal_record.dart';

final List<Exercise> defaultExercises = [
  Exercise(
    name: 'Bench Press',
    description:
        'A compound exercise that targets the chest, shoulders, and triceps.',
    sets: [],
    recordType: RecordType.weightAndReps,
  ),
  Exercise(
    name: 'Squat',
    description: 'A compound exercise that targets the legs and glutes.',
    sets: [],
    recordType: RecordType.weightAndReps,
  ),
  Exercise(
    name: 'Deadlift',
    description: 'A compound exercise that targets the back, legs, and glutes.',
    sets: [],
    recordType: RecordType.weightAndReps,
  ),
  Exercise(
    name: 'Pull-ups',
    description: 'A compound exercise that targets the back and biceps.',
    sets: [],
    recordType: RecordType.reps,
  ),
  Exercise(
    name: 'Running',
    description: 'A cardiovascular exercise that targets the legs and core.',
    sets: [],
    recordType: RecordType.distance,
  ),
  Exercise(
    name: 'Plank',
    description: 'An isometric exercise that targets the core.',
    sets: [],
    recordType: RecordType.time,
  ),
];
