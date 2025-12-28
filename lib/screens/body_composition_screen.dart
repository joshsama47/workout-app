import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/body_composition.dart';
import '../providers/body_composition_provider.dart';
import 'add_body_composition_screen.dart';

class BodyCompositionScreen extends StatelessWidget {
  const BodyCompositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyCompositionProvider = Provider.of<BodyCompositionProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Composition'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddBodyCompositionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: bodyCompositionProvider.bodyCompositionHistory.length,
        itemBuilder: (context, index) {
          final entry = bodyCompositionProvider.bodyCompositionHistory[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMd().add_jm().format(entry.date),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  _buildInfoRow('Weight', '${entry.weight} kg'),
                  _buildInfoRow(
                    'Body Fat %',
                    '${entry.bodyFatPercentage} %',
                    rating: entry.bodyFatRating,
                  ),
                  _buildInfoRow(
                    'Muscle Mass',
                    '${entry.muscleMass} kg',
                    rating: entry.muscleMassRating,
                  ),
                  _buildInfoRow('Muscle Score', '${entry.muscleScore}'),
                  _buildInfoRow('BMI', '${entry.bmi}', rating: entry.bmiRating),
                  _buildInfoRow(
                    'Muscle Quality',
                    '${entry.muscleQuality}',
                    rating: entry.muscleQualityRating,
                  ),
                  _buildInfoRow(
                    'Visceral Fat Level',
                    '${entry.visceralFatLevel}',
                    rating: entry.visceralFatRating,
                  ),
                  _buildInfoRow(
                    'Bone Mass',
                    '${entry.boneMass} kg',
                    rating: entry.boneMassRating,
                  ),
                  _buildInfoRow(
                    'Body Water %',
                    '${entry.bodyWaterPercentage} %',
                  ),
                  _buildInfoRow(
                    'BMR',
                    '${entry.bmr} kcal',
                    rating: entry.bmrRating,
                  ),
                  _buildInfoRow('Metabolic Age', '${entry.metabolicAge} years'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    BodyCompositionRating? rating,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Row(
            children: [
              if (rating != null) ...[
                _buildRatingChip(rating),
                const SizedBox(width: 8),
              ],
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingChip(BodyCompositionRating rating) {
    Color color;
    String text;
    switch (rating) {
      case BodyCompositionRating.obese:
        color = Colors.red;
        text = 'Obese';
        break;
      case BodyCompositionRating.high:
        color = Colors.orange;
        text = 'High';
        break;
      case BodyCompositionRating.average:
        color = Colors.green;
        text = 'Average';
        break;
      case BodyCompositionRating.slightlyHigh:
        color = Colors.yellow;
        text = 'Slightly High';
        break;
      case BodyCompositionRating.under:
        color = Colors.blue;
        text = 'Under';
        break;
    }
    return Chip(
      label: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      padding: const EdgeInsets.all(2.0),
    );
  }
}
