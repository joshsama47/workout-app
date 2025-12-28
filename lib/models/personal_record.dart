import 'package:cloud_firestore/cloud_firestore.dart';

enum RecordType { weightAndReps, reps, time, distance }

class PersonalRecord {
  final String exerciseName;
  final RecordType type;
  final Map<String, dynamic> values;
  final DateTime date;

  PersonalRecord({
    required this.exerciseName,
    required this.type,
    required this.values,
    required this.date,
  });

  factory PersonalRecord.fromMap(Map<String, dynamic> map) {
    return PersonalRecord(
      exerciseName: map['exerciseName'],
      type: RecordType.values.firstWhere((e) => e.toString() == map['type']),
      values: Map<String, dynamic>.from(map['values']),
      date: (map['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'type': type.toString(),
      'values': values,
      'date': date,
    };
  }
}
