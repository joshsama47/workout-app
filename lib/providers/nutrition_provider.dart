import 'package:flutter/material.dart';
import 'package:myapp/models/nutrition/food_item.dart';
import 'package:myapp/models/nutrition/meal.dart';

class NutritionProvider with ChangeNotifier {
  final List<Meal> _meals = [
    Meal(
      name: 'Breakfast',
      items: [
        FoodItem(name: 'Oatmeal', calories: 150, protein: 5, carbs: 27, fat: 3),
        FoodItem(
          name: 'Banana',
          calories: 105,
          protein: 1,
          carbs: 27,
          fat: 0.4,
        ),
      ],
    ),
    Meal(
      name: 'Lunch',
      items: [
        FoodItem(
          name: 'Grilled Chicken Salad',
          calories: 350,
          protein: 40,
          carbs: 10,
          fat: 15,
        ),
      ],
    ),
    Meal(
      name: 'Dinner',
      items: [
        FoodItem(
          name: 'Salmon with Quinoa',
          calories: 500,
          protein: 45,
          carbs: 35,
          fat: 20,
        ),
      ],
    ),
  ];

  List<Meal> get meals => _meals;

  double get totalDailyCalories =>
      _meals.fold(0, (sum, meal) => sum + meal.totalCalories);
  double get totalDailyProtein =>
      _meals.fold(0, (sum, meal) => sum + meal.totalProtein);
  double get totalDailyCarbs =>
      _meals.fold(0, (sum, meal) => sum + meal.totalCarbs);
  double get totalDailyFat =>
      _meals.fold(0, (sum, meal) => sum + meal.totalFat);

  void addFoodItem(Meal meal, FoodItem foodItem) {
    final mealIndex = _meals.indexWhere((m) => m.name == meal.name);
    if (mealIndex != -1) {
      _meals[mealIndex].items.add(foodItem);
      notifyListeners();
    }
  }

  void deleteFoodItem(Meal meal, FoodItem foodItem) {
    final mealIndex = _meals.indexWhere((m) => m.name == meal.name);
    if (mealIndex != -1) {
      _meals[mealIndex].items.remove(foodItem);
      notifyListeners();
    }
  }

  void updateFoodItem(Meal meal, FoodItem oldFoodItem, FoodItem newFoodItem) {
    final mealIndex = _meals.indexWhere((m) => m.name == meal.name);
    if (mealIndex != -1) {
      final itemIndex = _meals[mealIndex].items.indexOf(oldFoodItem);
      if (itemIndex != -1) {
        _meals[mealIndex].items[itemIndex] = newFoodItem;
        notifyListeners();
      }
    }
  }
}
