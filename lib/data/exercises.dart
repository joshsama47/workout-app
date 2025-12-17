import '../models/exercise.dart';

final List<Exercise> exercises = [
  Exercise(
    id: 'e1',
    name: 'Push Ups',
    description: 'A basic bodyweight exercise for chest, shoulders, and triceps.',
    animation: 'assets/animations/pushup.json',
  ),
  Exercise(
    id: 'e2',
    name: 'Squats',
    description: 'A fundamental lower body exercise that targets the quadriceps, hamstrings, and glutes.',
    animation: 'assets/animations/squats.json',
  ),
  Exercise(
    id: 'e3',
    name: 'Jumping Jacks',
    description: 'A full-body cardiovascular exercise.',
    animation: 'assets/animations/jumping_jacks.json',
  ),
  Exercise(
    id: 'e4',
    name: 'Burpees',
    description: 'A high-intensity, full-body exercise.',
    animation: 'assets/animations/burpees.json',
  ),
  Exercise(
    id: 'e5',
    name: 'Plank',
    description: 'An isometric core strength exercise that involves maintaining a position similar to a push-up for the maximum possible time.',
    animation: 'assets/animations/plank.json',
  ),
];
