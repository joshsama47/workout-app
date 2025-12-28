import 'food_item.dart';

class Meal {
  final String name;
  final List<FoodItem> items;

  Meal({required this.name, required this.items});

  double get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0, (sum, item) => sum + item.fat);
}
