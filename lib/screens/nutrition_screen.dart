import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/nutrition/meal.dart';
import 'package:myapp/providers/nutrition_provider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: Consumer<NutritionProvider>(
        builder: (context, nutritionProvider, child) {
          return Column(
            children: [
              _buildHeader(nutritionProvider),
              _buildMacroChart(nutritionProvider),
              Expanded(
                child: ListView.builder(
                  itemCount: nutritionProvider.meals.length,
                  itemBuilder: (context, index) {
                    final meal = nutritionProvider.meals[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: meal.items.length,
                              itemBuilder: (context, index) {
                                final foodItem = meal.items[index];
                                return ListTile(
                                  title: Text(foodItem.name),
                                  subtitle: Text(
                                    '${foodItem.calories.toStringAsFixed(0)} kcal, P: ${foodItem.protein}g, C: ${foodItem.carbs}g, F: ${foodItem.fat}g',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          context.go(
                                            '/edit-food',
                                            extra: {
                                              'meal': meal,
                                              'foodItem': foodItem,
                                            },
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          Provider.of<NutritionProvider>(
                                            context,
                                            listen: false,
                                          ).deleteFoodItem(meal, foodItem);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8.0),
                            TextButton(
                              onPressed: () {
                                context.go('/add-food', extra: meal);
                              },
                              child: const Text('Add Food'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(NutritionProvider nutritionProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Daily Summary',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeaderItem(
                'Calories',
                nutritionProvider.totalDailyCalories.toStringAsFixed(0),
              ),
              _buildHeaderItem(
                'Protein',
                '${nutritionProvider.totalDailyProtein.toStringAsFixed(0)}g',
              ),
              _buildHeaderItem(
                'Carbs',
                '${nutritionProvider.totalDailyCarbs.toStringAsFixed(0)}g',
              ),
              _buildHeaderItem(
                'Fat',
                '${nutritionProvider.totalDailyFat.toStringAsFixed(0)}g',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildMacroChart(NutritionProvider nutritionProvider) {
    final totalProtein = nutritionProvider.totalDailyProtein;
    final totalCarbs = nutritionProvider.totalDailyCarbs;
    final totalFat = nutritionProvider.totalDailyFat;
    final totalMacros = totalProtein + totalCarbs + totalFat;

    if (totalMacros == 0) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.blue,
              value: totalProtein,
              title:
                  '${(totalProtein / totalMacros * 100).toStringAsFixed(0)}%',
              radius: 50,
            ),
            PieChartSectionData(
              color: Colors.green,
              value: totalCarbs,
              title: '${(totalCarbs / totalMacros * 100).toStringAsFixed(0)}%',
              radius: 50,
            ),
            PieChartSectionData(
              color: Colors.red,
              value: totalFat,
              title: '${(totalFat / totalMacros * 100).toStringAsFixed(0)}%',
              radius: 50,
            ),
          ],
        ),
      ),
    );
  }
}
