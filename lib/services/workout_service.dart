import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/personal_record.dart';
import 'package:myapp/models/workout.dart';
import 'package:myapp/models/workout_session.dart';
import 'package:myapp/services/personal_record_service.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PersonalRecordService _personalRecordService = PersonalRecordService();

  Future<void> saveWorkoutSession(String userId, WorkoutSession session) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('workout_sessions')
          .doc(session.sessionId)
          .set(session.toMap());

      for (final exercise in session.exercises) {
        final currentRecords = await _personalRecordService.getPersonalRecords(
          userId,
        );
        final record = currentRecords.firstWhere(
          (r) => r.exerciseName == exercise.name,
          orElse: () => PersonalRecord(
            exerciseName: exercise.name,
            type: exercise.recordType,
            values: {},
            date: DateTime.now(),
          ),
        );

        switch (exercise.recordType) {
          case RecordType.weightAndReps:
            final bestSet = exercise.sets.reduce((a, b) {
              final aWeight = a.reps.isNotEmpty ? a.reps.first.metrics?.rom ?? 0 : 0;
              final bWeight = b.reps.isNotEmpty ? b.reps.first.metrics?.rom ?? 0 : 0;
              if (aWeight > bWeight) return a;
              if (bWeight > aWeight) return b;
              return a.reps.length > b.reps.length ? a : b;
            });

            final currentMaxWeight = record.values['weight'] ?? 0;
            final currentMaxReps = record.values['reps'] ?? 0;

            if (bestSet.reps.isNotEmpty && (bestSet.reps.first.metrics?.rom ?? 0) > currentMaxWeight ||
                (bestSet.reps.isNotEmpty && (bestSet.reps.first.metrics?.rom ?? 0) == currentMaxWeight &&
                    bestSet.reps.length > currentMaxReps)) {
              final newRecord = PersonalRecord(
                exerciseName: exercise.name,
                type: exercise.recordType,
                values: {'weight': bestSet.reps.first.metrics?.rom ?? 0, 'reps': bestSet.reps.length},
                date: DateTime.now(),
              );
              await _personalRecordService.updatePersonalRecord(
                userId,
                newRecord,
              );
            }
            break;
          case RecordType.reps:
            final maxReps = exercise.sets
                .map((s) => s.reps.length)
                .reduce((max, current) => current > max ? current : max);
            final currentMaxReps = record.values['reps'] ?? 0;

            if (maxReps > currentMaxReps) {
              final newRecord = PersonalRecord(
                exerciseName: exercise.name,
                type: exercise.recordType,
                values: {'reps': maxReps},
                date: DateTime.now(),
              );
              await _personalRecordService.updatePersonalRecord(
                userId,
                newRecord,
              );
            }
            break;
          case RecordType.time:
            final time = exercise.sets.first.reps.isNotEmpty ? exercise.sets.first.reps.first.metrics?.tempoEccentric ?? 0 : 0;
            final currentTime = record.values['time_seconds'] ?? 0;

            if (time > currentTime) {
              final newRecord = PersonalRecord(
                exerciseName: exercise.name,
                type: exercise.recordType,
                values: {'time_seconds': time},
                date: DateTime.now(),
              );
              await _personalRecordService.updatePersonalRecord(
                userId,
                newRecord,
              );
            }
            break;
          case RecordType.distance:
            final distance = exercise.sets.first.reps.isNotEmpty ? exercise.sets.first.reps.first.metrics?.symmetryDifference ?? 0 : 0;
            final currentDistance = record.values['distance'] ?? 0;

            if (distance > currentDistance) {
              final newRecord = PersonalRecord(
                exerciseName: exercise.name,
                type: exercise.recordType,
                values: {
                  'distance': distance,
                  'unit': 'km', // Assuming the unit is always km
                },
                date: DateTime.now(),
              );
              await _personalRecordService.updatePersonalRecord(
                userId,
                newRecord,
              );
            }
            break;
        }
      }
    } catch (e) {
      // Left empty intentionally
    }
  }

  Stream<List<Workout>> getWorkouts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('workouts')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Workout.fromMap(doc.data())).toList(),
        );
  }

  Stream<List<WorkoutSession>> getWorkoutHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('workout_sessions')
        .orderBy('endTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WorkoutSession.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<List<WorkoutSession>> getWorkoutHistoryForChart(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('workout_sessions')
        .orderBy('endTime', descending: true)
        .get()
        .then(
          (snapshot) => snapshot.docs
              .map((doc) => WorkoutSession.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<int> getWorkoutStreak(String userId) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('workout_sessions')
        .orderBy('endTime', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    final sessions = snapshot.docs
        .map((doc) => WorkoutSession.fromMap(doc.data()))
        .toList();
    final workoutDates = sessions.map((s) => s.endTime?.toLocal()).toSet();

    int streak = 0;
    DateTime today = DateTime.now();
    DateTime currentDate = DateTime(today.year, today.month, today.day);

    while (workoutDates.any(
      (date) =>
          date?.year == currentDate.year &&
          date?.month == currentDate.month &&
          date?.day == currentDate.day,
    )) {
      streak++;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    return streak;
  }
}
