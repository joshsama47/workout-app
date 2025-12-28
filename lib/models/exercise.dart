import 'package:myapp/models/personal_record.dart';

import 'equipment.dart';
import 'package:myapp/models/workout_session.dart';

class Exercise {
  final String? id;
  final String name;
  final String? description;
  final String? animation;
  final List<Equipment>? equipment;
  final Map<String, dynamic>? fsmDefinition;
  final List<ExerciseSet> sets;
  final RecordType recordType;

  Exercise({
    this.id,
    required this.name,
    this.description,
    this.animation,
    this.equipment,
    this.fsmDefinition,
    required this.sets,
    required this.recordType,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      animation: map['animation'],
      equipment: map['equipment'] != null
          ? List<Equipment>.from(
              map['equipment']?.map((x) => Equipment.fromMap(x)),
            )
          : null,
      fsmDefinition: map['fsmDefinition'],
      sets: List<ExerciseSet>.from(
        map['sets']?.map((x) => ExerciseSet.fromMap(x)),
      ),
      recordType: RecordType.values.firstWhere(
        (e) => e.toString() == map['recordType'],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'animation': animation,
      'equipment': equipment?.map((x) => x.toMap()).toList(),
      'fsmDefinition': fsmDefinition,
      'sets': sets.map((x) => x.toMap()).toList(),
      'recordType': recordType.toString(),
    };
  }

  Exercise copyWith({
    String? id,
    String? name,
    String? description,
    String? animation,
    List<Equipment>? equipment,
    Map<String, dynamic>? fsmDefinition,
    List<ExerciseSet>? sets,
    RecordType? recordType,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      animation: animation ?? this.animation,
      equipment: equipment ?? this.equipment,
      fsmDefinition: fsmDefinition ?? this.fsmDefinition,
      sets: sets ?? this.sets,
      recordType: recordType ?? this.recordType,
    );
  }
}
