import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/personal_record.dart';

class PersonalRecordCard extends StatelessWidget {
  final PersonalRecord record;

  const PersonalRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(record.exerciseName),
        subtitle: Text(_buildSubtitle()),
      ),
    );
  }

  String _buildSubtitle() {
    String subtitle = '';
    switch (record.type) {
      case RecordType.weightAndReps:
        subtitle =
            '${record.values['weight']} kg for ${record.values['reps']} reps';
        break;
      case RecordType.reps:
        subtitle = '${record.values['reps']} reps';
        break;
      case RecordType.time:
        subtitle = '${record.values['time_seconds']} seconds';
        break;
      case RecordType.distance:
        subtitle = '${record.values['distance']} ${record.values['unit']}';
        break;
    }
    return '$subtitle on ${DateFormat.yMMMd().format(record.date)}';
  }
}
