class MealPlan {
  final String id;
  final String name;
  final String description;
  final Map<String, String>
  meals; // e.g., {'Breakfast': 'Oatmeal', 'Lunch': 'Salad', 'Dinner': 'Chicken'}

  MealPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.meals,
  });
}
