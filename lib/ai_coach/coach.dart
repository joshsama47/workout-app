import 'package:myapp/models/workout_session.dart';

class Coach {
  List<CoachFeedback> analyzeRep(Rep rep, String exerciseName) {
    final List<CoachFeedback> feedback = [];
    if (rep.metrics == null) return feedback;

    switch (exerciseName) {
      case 'Squat':
        // Rule 1: Check Range of Motion (ROM)
        if ((rep.metrics!.rom ?? 100) < 80) {
          feedback.add(
            CoachFeedback(
              feedbackCode: 'SQUAT_SHALLOW',
              message: 'Try to go a little deeper in your squat.',
              timestamp: DateTime.now(),
            ),
          );
        }

        // Rule 2: Check for excessive forward lean
        if ((rep.metrics!.maxTorsoLean ?? 0) > 45) {
          feedback.add(
            CoachFeedback(
              feedbackCode: 'SQUAT_LEAN_FORWARD',
              message: 'Keep your chest up and back straight.',
              timestamp: DateTime.now(),
            ),
          );
        }

        // Rule 3: Check eccentric tempo (lowering phase)
        if ((rep.metrics!.tempoEccentric ?? 2000) < 1000) {
          feedback.add(
            CoachFeedback(
              feedbackCode: 'SQUAT_TOO_FAST_DOWN',
              message:
                  'Control your descent. Aim for a slower, more controlled movement on the way down.',
              timestamp: DateTime.now(),
            ),
          );
        }
        break;
      // Add cases for other exercises like Push-up, Sit-up, etc. here
    }

    return feedback;
  }
}
