import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/exercise.dart';
import '../models/workout.dart';
import 'add_exercise_modal.dart';

class CreateWorkoutForm extends StatefulWidget {
  final Function(Workout) onWorkoutCreated;

  const CreateWorkoutForm({super.key, required this.onWorkoutCreated});

  @override
  State<CreateWorkoutForm> createState() => _CreateWorkoutFormState();
}

class _CreateWorkoutFormState extends State<CreateWorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  final List<Exercise> _exercises = [];

  void _addExercise(Exercise exercise) {
    setState(() {
      _exercises.add(exercise);
    });
  }

  void _showAddExerciseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddExerciseModal(onExerciseAdded: _addExercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Workout Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
            ),
            const SizedBox(height: 20),
            _buildExerciseList(),
            TextButton.icon(
              onPressed: _showAddExerciseModal,
              icon: const Icon(Icons.add),
              label: const Text('Add Exercise'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newWorkout = Workout(
                    id: const Uuid().v4(),
                    name: _name,
                    description: _description,
                    exercises: _exercises,
                  );
                  widget.onWorkoutCreated(newWorkout);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create Workout'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    if (_exercises.isEmpty) {
      return const Text('No exercises added yet.');
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _exercises.length,
      itemBuilder: (context, index) {
        final exercise = _exercises[index];
        return ListTile(
          title: Text(exercise.name),
          subtitle: Text(exercise.description ?? ''),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _exercises.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }
}
