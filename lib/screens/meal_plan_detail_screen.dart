import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/meal_plan.dart';
import '../services/notification_service.dart';

class MealPlanDetailScreen extends StatefulWidget {
  final MealPlan mealPlan;

  const MealPlanDetailScreen({super.key, required this.mealPlan});

  @override
  State<MealPlanDetailScreen> createState() => _MealPlanDetailScreenState();
}

class _MealPlanDetailScreenState extends State<MealPlanDetailScreen> {
  Future<void> _setReminder(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      NotificationService.scheduleNotification(
        'Time for your meal!',
        'Don\'t forget to eat your ${widget.mealPlan.name} meal.',
        scheduledTime,
      );
      messenger.showSnackBar(const SnackBar(content: Text('Reminder set!')));
    } else {
      messenger.showSnackBar(const SnackBar(content: Text('No reminder set.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mealPlan.name,
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.mealPlan.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Meals',
              style: GoogleFonts.oswald(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.mealPlan.meals.length,
                itemBuilder: (context, index) {
                  final mealType = widget.mealPlan.meals.keys.elementAt(index);
                  final meal = widget.mealPlan.meals[mealType]!;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        mealType,
                        style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(meal),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _setReminder(context),
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
