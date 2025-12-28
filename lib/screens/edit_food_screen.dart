import 'package:flutter/material.dart';
import 'package:myapp/models/nutrition/food_item.dart';
import 'package:myapp/models/nutrition/meal.dart';
import 'package:myapp/providers/nutrition_provider.dart';
import 'package:provider/provider.dart';

class EditFoodScreen extends StatefulWidget {
  final Meal meal;
  final FoodItem foodItem;

  const EditFoodScreen({super.key, required this.meal, required this.foodItem});

  @override
  _EditFoodScreenState createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _proteinController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.foodItem.name);
    _caloriesController = TextEditingController(
      text: widget.foodItem.calories.toString(),
    );
    _proteinController = TextEditingController(
      text: widget.foodItem.protein.toString(),
    );
    _carbsController = TextEditingController(
      text: widget.foodItem.carbs.toString(),
    );
    _fatController = TextEditingController(
      text: widget.foodItem.fat.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Food in ${widget.meal.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the calories';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _proteinController,
                decoration: const InputDecoration(labelText: 'Protein (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the protein';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _carbsController,
                decoration: const InputDecoration(labelText: 'Carbs (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the carbs';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fatController,
                decoration: const InputDecoration(labelText: 'Fat (g)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the fat';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedFoodItem = FoodItem(
                      name: _nameController.text,
                      calories: double.parse(_caloriesController.text),
                      protein: double.parse(_proteinController.text),
                      carbs: double.parse(_carbsController.text),
                      fat: double.parse(_fatController.text),
                    );
                    Provider.of<NutritionProvider>(
                      context,
                      listen: false,
                    ).updateFoodItem(
                      widget.meal,
                      widget.foodItem,
                      updatedFoodItem,
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
