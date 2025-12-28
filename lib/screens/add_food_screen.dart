import 'package:flutter/material.dart';
import 'package:myapp/models/nutrition/food_item.dart';
import 'package:myapp/models/nutrition/meal.dart';
import 'package:myapp/providers/nutrition_provider.dart';
import 'package:provider/provider.dart';

class AddFoodScreen extends StatefulWidget {
  final Meal meal;

  const AddFoodScreen({super.key, required this.meal});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Food to ${widget.meal.name}')),
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
                    final foodItem = FoodItem(
                      name: _nameController.text,
                      calories: double.parse(_caloriesController.text),
                      protein: double.parse(_proteinController.text),
                      carbs: double.parse(_carbsController.text),
                      fat: double.parse(_fatController.text),
                    );
                    Provider.of<NutritionProvider>(
                      context,
                      listen: false,
                    ).addFoodItem(widget.meal, foodItem);
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
