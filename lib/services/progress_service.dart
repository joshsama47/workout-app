import 'dart:collection';
import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/models/workout_session.dart';

class ProgressService with ChangeNotifier {
  final List<WorkoutSession> _completedWorkouts = [];

  UnmodifiableListView<WorkoutSession> get completedWorkouts =>
      UnmodifiableListView(_completedWorkouts);

  Future<void> fetchCompletedWorkouts(String userId) async {
    if (userId.isEmpty) return;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('workout_sessions')
          .orderBy('endTime', descending: true)
          .get();

      _completedWorkouts.clear();
      for (var doc in snapshot.docs) {
        _completedWorkouts.add(WorkoutSession.fromJson(doc.data()));
      }
      notifyListeners();
    } catch (e, s) {
      developer.log(
        'Error fetching completed workouts',
        name: 'myapp.progress_service',
        error: e,
        stackTrace: s,
      );
    }
  }

  void addCompletedWorkout(WorkoutSession workout) {
    _completedWorkouts.insert(0, workout);
    notifyListeners();
  }

  int get weeklyWorkoutCount {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );
    return _completedWorkouts.where((workout) {
      return workout.endTime != null && workout.endTime!.isAfter(startOfWeek);
    }).length;
  }

  int get streak {
    // This is a simplified streak calculation. A more robust implementation
    // would be needed for a real app.
    return _completedWorkouts.length;
  }

  int get totalPoints {
    // Assuming each workout session is worth 10 points
    return _completedWorkouts.length * 10;
  }
}
