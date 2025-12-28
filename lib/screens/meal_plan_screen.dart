import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/meal_plans.dart';
import 'meal_plan_detail_screen.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meal Plans',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: mealPlans.length,
        itemBuilder: (context, index) {
          final mealPlan = mealPlans[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              title: Text(
                mealPlan.name,
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(mealPlan.description),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MealPlanDetailScreen(mealPlan: mealPlan),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
