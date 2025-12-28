import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/body_composition.dart';
import '../providers/body_composition_provider.dart';

class AddBodyCompositionScreen extends StatefulWidget {
  const AddBodyCompositionScreen({super.key});

  @override
  AddBodyCompositionScreenState createState() =>
      AddBodyCompositionScreenState();
}

class AddBodyCompositionScreenState extends State<AddBodyCompositionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _bodyFatPercentageController = TextEditingController();
  final _muscleMassController = TextEditingController();
  final _muscleScoreController = TextEditingController();
  final _bmiController = TextEditingController();
  final _muscleQualityController = TextEditingController();
  final _visceralFatLevelController = TextEditingController();
  final _boneMassController = TextEditingController();
  final _bodyWaterPercentageController = TextEditingController();
  final _bmrController = TextEditingController();
  final _metabolicAgeController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newEntry = BodyComposition(
        id: const Uuid().v4(),
        date: DateTime.now(),
        weight: double.parse(_weightController.text),
        bodyFatPercentage: double.parse(_bodyFatPercentageController.text),
        muscleMass: double.parse(_muscleMassController.text),
        muscleScore: int.parse(_muscleScoreController.text),
        bmi: double.parse(_bmiController.text),
        muscleQuality: int.parse(_muscleQualityController.text),
        visceralFatLevel: double.parse(_visceralFatLevelController.text),
        boneMass: double.parse(_boneMassController.text),
        bodyWaterPercentage: double.parse(_bodyWaterPercentageController.text),
        bmr: int.parse(_bmrController.text),
        metabolicAge: int.parse(_metabolicAgeController.text),
      );
      Provider.of<BodyCompositionProvider>(
        context,
        listen: false,
      ).addBodyComposition(newEntry);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Body Composition')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextFormField(_weightController, 'Weight (kg)'),
              _buildTextFormField(_bodyFatPercentageController, 'Body Fat %'),
              _buildTextFormField(_muscleMassController, 'Muscle Mass (kg)'),
              _buildTextFormField(_muscleScoreController, 'Muscle Score'),
              _buildTextFormField(_bmiController, 'BMI'),
              _buildTextFormField(_muscleQualityController, 'Muscle Quality'),
              _buildTextFormField(
                _visceralFatLevelController,
                'Visceral Fat Level',
              ),
              _buildTextFormField(_boneMassController, 'Bone Mass (kg)'),
              _buildTextFormField(
                _bodyWaterPercentageController,
                'Body Water %',
              ),
              _buildTextFormField(_bmrController, 'BMR (kcal)'),
              _buildTextFormField(_metabolicAgeController, 'Metabolic Age'),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submitForm, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          return null;
        },
      ),
    );
  }
}
