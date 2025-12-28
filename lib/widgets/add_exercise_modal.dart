import 'package:flutter/material.dart';
import 'package:myapp/models/workout_session.dart';

import '../models/exercise.dart';

class AddExerciseModal extends StatefulWidget {
  final Function(Exercise) onExerciseAdded;

  const AddExerciseModal({super.key, required this.onExerciseAdded});

  @override
  State<AddExerciseModal> createState() => _AddExerciseModalState();
}

class _AddExerciseModalState extends State<AddExerciseModal> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  int _sets = 0;

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
              decoration: const InputDecoration(labelText: 'Exercise Name'),
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
            TextFormField(
              decoration: const InputDecoration(labelText: 'Sets'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _sets = int.tryParse(value!) ?? 0,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final sets = List.generate(
                    _sets,
                    (index) => ExerciseSet(setNumber: index + 1, reps: []),
                  );
                  widget.onExerciseAdded(
                    Exercise(
                      name: _name,
                      description: _description,
                      sets: sets,
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }
}
