import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/exercises.dart';
import '../models/custom_workout_model.dart';
import '../models/exercise.dart';
import '../providers/custom_workout_provider.dart';

class CustomWorkoutBuilderScreen extends StatefulWidget {
  const CustomWorkoutBuilderScreen({super.key});

  @override
  State<CustomWorkoutBuilderScreen> createState() =>
      _CustomWorkoutBuilderScreenState();
}

class _CustomWorkoutBuilderScreenState
    extends State<CustomWorkoutBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  String _workoutName = '';
  final List<Exercise> _selectedExercises = [];

  void _showAddExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Exercise'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: allExercises.length,
              itemBuilder: (context, index) {
                final exercise = allExercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  onTap: () {
                    setState(() {
                      _selectedExercises.add(exercise);
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    setState(() {
      _workoutName = '';
      _selectedExercises.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Custom Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearForm,
            tooltip: 'Clear Workout',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _selectedExercises.isNotEmpty
                ? () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final newWorkout = CustomWorkout(
                        name: _workoutName,
                        exercises: List.from(_selectedExercises),
                      );
                      Provider.of<CustomWorkoutProvider>(
                        context,
                        listen: false,
                      ).addCustomWorkout(newWorkout);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Workout saved!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      _clearForm();
                    }
                  }
                : null,
            tooltip: 'Save Workout',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Workout Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _workoutName = value!;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Exercises',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _selectedExercises.isEmpty
                    ? const Center(
                        child: Text(
                          'No exercises added yet. Tap the + button to add some!',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _selectedExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = _selectedExercises[index];
                          return Card(
                            child: ListTile(
                              title: Text(exercise.name),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedExercises.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExerciseDialog,
        label: const Text('Add Exercise'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
