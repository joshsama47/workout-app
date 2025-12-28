import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/models/exercise.dart';

class WorkoutSession {
  final String sessionId;
  final String workoutName;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final List<Exercise> exercises;

  WorkoutSession({
    required this.sessionId,
    required this.workoutName,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'sessionId': sessionId,
      'workoutName': workoutName,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'exercises': exercises.map((x) => x.toMap()).toList(),
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      sessionId: map['sessionId'],
      workoutName: map['workoutName'],
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: map['endTime'] != null
          ? (map['endTime'] as Timestamp).toDate()
          : null,
      status: map['status'],
      exercises: List<Exercise>.from(
        map['exercises']?.map((x) => Exercise.fromMap(x)),
      ),
    );
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json) =>
      WorkoutSession.fromMap(json);
}

class ExerciseSet {
  final int setNumber;
  final List<Rep> reps;

  ExerciseSet({required this.setNumber, required this.reps});

  Map<String, dynamic> toMap() {
    return {
      'setNumber': setNumber,
      'reps': reps.map((x) => x.toMap()).toList(),
    };
  }

  factory ExerciseSet.fromMap(Map<String, dynamic> map) {
    return ExerciseSet(
      setNumber: map['setNumber'],
      reps: List<Rep>.from(map['reps']?.map((x) => Rep.fromMap(x))),
    );
  }
}

class Rep {
  final int repNumber;
  final bool isCompleted;
  final DateTime startTime;
  final DateTime? endTime;
  final RepMetrics? metrics;
  final List<CoachFeedback> coachFeedback;

  Rep({
    required this.repNumber,
    required this.isCompleted,
    required this.startTime,
    this.endTime,
    this.metrics,
    required this.coachFeedback,
  });

  Map<String, dynamic> toMap() {
    return {
      'repNumber': repNumber,
      'isCompleted': isCompleted,
      'startTime': startTime,
      'endTime': endTime,
      'metrics': metrics?.toMap(),
      'coachFeedback': coachFeedback.map((x) => x.toMap()).toList(),
    };
  }

  factory Rep.fromMap(Map<String, dynamic> map) {
    return Rep(
      repNumber: map['repNumber'],
      isCompleted: map['isCompleted'],
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: map['endTime'] != null
          ? (map['endTime'] as Timestamp).toDate()
          : null,
      metrics: map['metrics'] != null
          ? RepMetrics.fromMap(map['metrics'])
          : null,
      coachFeedback: List<CoachFeedback>.from(
        map['coachFeedback']?.map((x) => CoachFeedback.fromMap(x)),
      ),
    );
  }

  Rep copyWith({
    int? repNumber,
    bool? isCompleted,
    DateTime? startTime,
    DateTime? endTime,
    RepMetrics? metrics,
    List<CoachFeedback>? coachFeedback,
  }) {
    return Rep(
      repNumber: repNumber ?? this.repNumber,
      isCompleted: isCompleted ?? this.isCompleted,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      metrics: metrics ?? this.metrics,
      coachFeedback: coachFeedback ?? this.coachFeedback,
    );
  }
}

class RepMetrics {
  final double? rom;
  final double? tempoEccentric;
  final double? tempoConcentric;
  final double? symmetryDifference;
  final double? maxTorsoLean;

  RepMetrics({
    this.rom,
    this.tempoEccentric,
    this.tempoConcentric,
    this.symmetryDifference,
    this.maxTorsoLean,
  });

  Map<String, dynamic> toMap() {
    return {
      'rom': rom,
      'tempoEccentric': tempoEccentric,
      'tempoConcentric': tempoConcentric,
      'symmetryDifference': symmetryDifference,
      'maxTorsoLean': maxTorsoLean,
    };
  }

  factory RepMetrics.fromMap(Map<String, dynamic> map) {
    return RepMetrics(
      rom: map['rom'],
      tempoEccentric: map['tempoEccentric'],
      tempoConcentric: map['tempoConcentric'],
      symmetryDifference: map['symmetryDifference'],
      maxTorsoLean: map['maxTorsoLean'],
    );
  }
}

class CoachFeedback {
  final String feedbackCode;
  final String message;
  final DateTime timestamp;

  CoachFeedback({
    required this.feedbackCode,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'feedbackCode': feedbackCode,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory CoachFeedback.fromMap(Map<String, dynamic> map) {
    return CoachFeedback(
      feedbackCode: map['feedbackCode'],
      message: map['message'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
