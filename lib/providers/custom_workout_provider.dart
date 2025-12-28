import 'package:flutter/material.dart';
import 'package:myapp/models/custom_workout_model.dart';

class CustomWorkoutProvider with ChangeNotifier {
  final List<CustomWorkout> _customWorkouts = [];

  List<CustomWorkout> get customWorkouts => _customWorkouts;

  void addCustomWorkout(CustomWorkout workout) {
    _customWorkouts.add(workout);
    notifyListeners();
  }
}
