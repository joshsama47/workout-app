enum BodyCompositionRating { obese, high, average, slightlyHigh, under }

class BodyComposition {
  final String id;
  final DateTime date;
  final double weight;
  final double bodyFatPercentage;
  final BodyCompositionRating? bodyFatRating;
  final double muscleMass;
  final BodyCompositionRating? muscleMassRating;
  final int muscleScore;
  final double bmi;
  final BodyCompositionRating? bmiRating;
  final int muscleQuality;
  final BodyCompositionRating? muscleQualityRating;
  final double visceralFatLevel;
  final BodyCompositionRating? visceralFatRating;
  final double boneMass;
  final BodyCompositionRating? boneMassRating;
  final double bodyWaterPercentage;
  final int bmr;
  final BodyCompositionRating? bmrRating;
  final int metabolicAge;

  BodyComposition({
    required this.id,
    required this.date,
    required this.weight,
    required this.bodyFatPercentage,
    this.bodyFatRating,
    required this.muscleMass,
    this.muscleMassRating,
    required this.muscleScore,
    required this.bmi,
    this.bmiRating,
    required this.muscleQuality,
    this.muscleQualityRating,
    required this.visceralFatLevel,
    this.visceralFatRating,
    required this.boneMass,
    this.boneMassRating,
    required this.bodyWaterPercentage,
    required this.bmr,
    this.bmrRating,
    required this.metabolicAge,
  });
}
