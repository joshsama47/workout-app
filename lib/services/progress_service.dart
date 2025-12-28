import 'package:myapp/models/workout_session.dart';

class ProgressService {
  List<Map<String, dynamic>> getStrengthProgression(
    List<WorkoutSession> sessions,
    String exerciseName,
  ) {
    final relevantSessions = sessions
        .where((s) => s.exercises.any((e) => e.name == exerciseName))
        .toList();

    relevantSessions.sort((a, b) => a.startTime.compareTo(b.startTime));

    return relevantSessions.map((session) {
      final exercise = session.exercises.firstWhere(
        (e) => e.name == exerciseName,
      );
      final maxWeight = exercise.sets
          .map((s) => s.reps.map((r) => r.metrics?.rom ?? 0).reduce((max, current) => current > max ? current : max))
          .reduce((max, current) => current > max ? current : max);

      return {'date': session.startTime, 'value': maxWeight};
    }).toList();
  }

  List<Map<String, dynamic>> getVolumeProgression(
    List<WorkoutSession> sessions,
  ) {
    final weeklyVolume = <DateTime, double>{};

    for (final session in sessions) {
      final weekStart = _getWeekStart(session.startTime);
      final sessionVolume = session.exercises
          .map(
            (e) => e.sets.map((s) => s.reps.map((r) => r.metrics?.rom ?? 0).reduce((a, b) => a + b)).reduce((a, b) => a + b),
          )
          .reduce((a, b) => a + b);

      weeklyVolume.update(
        weekStart,
        (value) => value + sessionVolume,
        ifAbsent: () => sessionVolume.toDouble(),
      );
    }

    return weeklyVolume.entries.map((entry) {
      return {'date': entry.key, 'value': entry.value};
    }).toList();
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }
}
