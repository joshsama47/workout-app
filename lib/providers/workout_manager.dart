import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/exercise.dart';

class WorkoutManager with ChangeNotifier {
  final List<Workout> _workouts = [];

  List<Workout> get workouts => _workouts;

  void addWorkout(String workoutJson) {
    final workoutData = jsonDecode(workoutJson);
    final exercises = (workoutData['exercises'] as List).map((e) {
      return Exercise(
        id: e['id'] ?? '',
        name: e['name'] ?? '',
        description: e['description'] ?? '',
        animation: e['animation'] ?? '',
        sets: [],
      );
    }).toList();

    final workout = Workout(
      id: workoutData['id'] ?? '',
      name: workoutData['name'] ?? '',
      exercises: exercises,
      sets: workoutData['sets'] ?? 0,
      reps: workoutData['reps'] ?? 0,
      rest: workoutData['rest'] ?? 0,
      duration: workoutData['duration'] ?? 0,
    );

    _workouts.add(workout);
    notifyListeners();
  }

  void clearWorkouts() {
    _workouts.clear();
    notifyListeners();
  }
}
