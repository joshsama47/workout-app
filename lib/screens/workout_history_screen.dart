import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/screens/workout_summary_screen.dart';
import 'package:provider/provider.dart';

import '../services/progress_service.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: const Center(
        child: Text(
          'No workouts completed yet.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
