import 'package:myapp/pose_detection/repetition_counter.dart';

class ExerciseModel {
  final String name;
  late final RepetitionCounter repetitionCounter;

  ExerciseModel(this.name) {
    switch (name.toLowerCase()) {
      case 'squat':
        repetitionCounter = SquatRepetitionCounter();
        break;
      case 'push-up':
        repetitionCounter = PushUpRepetitionCounter();
        break;
      case 'jumping jack':
        repetitionCounter = JumpingJackRepetitionCounter();
        break;
      default:
        throw Exception('Unknown exercise: $name');
    }
  }
}
