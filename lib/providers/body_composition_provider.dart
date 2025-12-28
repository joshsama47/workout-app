import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/body_composition.dart';

class BodyCompositionProvider with ChangeNotifier {
  final List<BodyComposition> _bodyCompositionHistory = [
    BodyComposition(
      id: const Uuid().v4(),
      date: DateTime.now().subtract(const Duration(days: 30)),
      weight: 88.0,
      bodyFatPercentage: 32.0,
      bodyFatRating: BodyCompositionRating.obese,
      muscleMass: 56.0,
      muscleMassRating: BodyCompositionRating.high,
      muscleScore: 2,
      bmi: 31.0,
      bmiRating: BodyCompositionRating.obese,
      muscleQuality: 70,
      muscleQualityRating: BodyCompositionRating.average,
      visceralFatLevel: 14.0,
      visceralFatRating: BodyCompositionRating.slightlyHigh,
      boneMass: 3.0,
      boneMassRating: BodyCompositionRating.high,
      bodyWaterPercentage: 47.0,
      bmr: 1700,
      bmrRating: BodyCompositionRating.under,
      metabolicAge: 42,
    ),
    BodyComposition(
      id: const Uuid().v4(),
      date: DateTime.now(),
      weight: 87.1,
      bodyFatPercentage: 30.6,
      bodyFatRating: BodyCompositionRating.obese,
      muscleMass: 57.35,
      muscleMassRating: BodyCompositionRating.high,
      muscleScore: 2,
      bmi: 30.1,
      bmiRating: BodyCompositionRating.obese,
      muscleQuality: 73,
      muscleQualityRating: BodyCompositionRating.average,
      visceralFatLevel: 13.0,
      visceralFatRating: BodyCompositionRating.slightlyHigh,
      boneMass: 3.1,
      boneMassRating: BodyCompositionRating.high,
      bodyWaterPercentage: 48.3,
      bmr: 1759,
      bmrRating: BodyCompositionRating.under,
      metabolicAge: 40,
    ),
  ];

  List<BodyComposition> get bodyCompositionHistory => _bodyCompositionHistory;

  void addBodyComposition(BodyComposition newEntry) {
    _bodyCompositionHistory.add(newEntry);
    notifyListeners();
  }
}
