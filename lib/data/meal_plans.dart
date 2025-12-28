import '../models/meal_plan.dart';

final mealPlans = [
  MealPlan(
    id: 'keto',
    name: 'Keto Diet',
    description: 'A low-carb, high-fat diet.',
    meals: {
      'Breakfast': 'Avocado and Eggs',
      'Lunch': 'Grilled Chicken Salad',
      'Dinner': 'Salmon with Asparagus',
    },
  ),
  MealPlan(
    id: 'paleo',
    name: 'Paleo Diet',
    description:
        'Based on foods presumed to have been available to Paleolithic humans.',
    meals: {
      'Breakfast': 'Fruit and Nuts',
      'Lunch': 'Lean meat and vegetables',
      'Dinner': 'Fish and sweet potatoes',
    },
  ),
  MealPlan(
    id: 'vegan',
    name: 'Vegan Diet',
    description: 'A diet that excludes all animal products.',
    meals: {
      'Breakfast': 'Tofu Scramble',
      'Lunch': 'Lentil Soup',
      'Dinner': 'Vegetable Stir-fry',
    },
  ),
];
