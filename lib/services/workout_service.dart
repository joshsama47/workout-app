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

      for (final exercise in session.workout.exercises) {
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
              if (a.weight > b.weight) return a;
              if (b.weight > a.weight) return b;
              return a.reps > b.reps ? a : b;
            });

            final currentMaxWeight = record.values['weight'] ?? 0;
            final currentMaxReps = record.values['reps'] ?? 0;

            if (bestSet.weight > currentMaxWeight ||
                (bestSet.weight == currentMaxWeight &&
                    bestSet.reps > currentMaxReps)) {
              final newRecord = PersonalRecord(
                exerciseName: exercise.name,
                type: exercise.recordType,
                values: {'weight': bestSet.weight, 'reps': bestSet.reps},
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
                .map((s) => s.reps)
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
            // Assuming the time is stored in the 'duration' field of the first set
            final time = exercise.sets.first.duration ?? 0;
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
            // Assuming the distance is stored in the 'distance' field of the first set
            final distance = exercise.sets.first.distance ?? 0;
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
      print('Error saving workout session: $e');
      rethrow;
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
}
