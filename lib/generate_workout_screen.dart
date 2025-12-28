import 'package:flutter/material.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:go_router/go_router.dart';

class GenerateWorkoutScreen extends StatefulWidget {
  const GenerateWorkoutScreen({super.key});

  @override
  State<GenerateWorkoutScreen> createState() => _GenerateWorkoutScreenState();
}

class _GenerateWorkoutScreenState extends State<GenerateWorkoutScreen> {
  bool _isLoading = false;

  // User preferences
  final List<String> _availableGoals = [
    'Build Muscle',
    'Lose Fat',
    'Improve Endurance',
    'Increase Strength',
  ];
  final List<String> _availableEquipment = [
    'Dumbbells',
    'Barbell',
    'Kettlebell',
    'Resistance Bands',
    'Bodyweight',
  ];
  final List<String> _selectedGoals = [];
  final List<String> _selectedEquipment = [
    'Bodyweight',
  ]; // Default to bodyweight
  double _workoutDuration = 30;

  Future<void> _generateWorkout() async {
    if (_selectedGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one fitness goal.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final model = FirebaseAI.vertexAI().generativeModel(
      model: 'gemini-1.5-flash',
    );
    final prompt =
        '''
    Create a workout with the following criteria:
    - Fitness Goals: ${_selectedGoals.join(', ')}
    - Available Equipment: ${_selectedEquipment.join(', ')}
    - Desired Duration: ${_workoutDuration.toInt()} minutes

    The output must be a single, valid JSON object with the following structure:
    {
      "id": "gen-WORKOUT_ID",
      "name": "Generated Workout Name",
      "description": "A brief description of the workout.",
      "duration": ${_workoutDuration.toInt()},
      "sets": 3,
      "reps": 12,
      "rest": 60,
      "exercises": [
        {
          "id": "gen-EXERCISE_ID",
          "name": "Exercise Name",
          "description": "How to perform the exercise.",
          "animation": "assets/animations/placeholder.json"
        }
      ]
    }
    Ensure the generated workout can be realistically completed within the specified duration.
    Do not include any text or formatting outside of the JSON object.
    ''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final workoutJson = response.text;
      if (workoutJson != null && mounted) {
        context.go('/workout', extra: workoutJson);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate workout: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generate Personalized Workout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Your Fitness Goals'),
            _buildChipSelection(
              available: _availableGoals,
              selected: _selectedGoals,
              onSelected: (value) {
                setState(() {
                  if (_selectedGoals.contains(value)) {
                    _selectedGoals.remove(value);
                  } else {
                    _selectedGoals.add(value);
                  }
                });
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Available Equipment'),
            _buildChipSelection(
              available: _availableEquipment,
              selected: _selectedEquipment,
              onSelected: (value) {
                setState(() {
                  if (_selectedEquipment.contains(value)) {
                    if (_selectedEquipment.length > 1) {
                      // Prevent removing the last one
                      _selectedEquipment.remove(value);
                    }
                  } else {
                    _selectedEquipment.add(value);
                  }
                });
              },
            ),
            const SizedBox(height: 24),
            _buildSectionTitle(
              'Workout Duration: ${_workoutDuration.toInt()} minutes',
            ),
            _buildDurationSlider(),
            const SizedBox(height: 32),
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.smart_toy_outlined),
                      onPressed: _generateWorkout,
                      label: const Text('Generate with AI'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildChipSelection({
    required List<String> available,
    required List<String> selected,
    required ValueChanged<String> onSelected,
  }) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: available.map((item) {
        return ChoiceChip(
          label: Text(item),
          selected: selected.contains(item),
          onSelected: (isSelected) => onSelected(item),
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(
            color: selected.contains(item)
                ? Theme.of(context).colorScheme.onPrimary
                : null,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDurationSlider() {
    return Slider(
      value: _workoutDuration,
      min: 15,
      max: 90,
      divisions: 5, // (90-15) / 15 = 5
      label: '${_workoutDuration.toInt()} min',
      onChanged: (double value) {
        setState(() {
          _workoutDuration = value;
        });
      },
    );
  }
}
