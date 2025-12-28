import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/workout_plan.dart';

class WorkoutPlanDetailScreen extends StatelessWidget {
  final WorkoutPlan plan;

  const WorkoutPlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          plan.name,
          style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: plan.workouts.length,
        itemBuilder: (context, index) {
          final day = plan.workouts.keys.elementAt(index);
          final workout = plan.workouts[day]!;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                day,
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                workout.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/workout/${workout.id}');
              },
            ),
          );
        },
      ),
    );
  }
}
