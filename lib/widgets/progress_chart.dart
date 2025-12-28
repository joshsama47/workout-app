import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/models/workout_session.dart';
import 'package:intl/intl.dart';

class ProgressChart extends StatelessWidget {
  final List<WorkoutSession> sessions;
  final String exerciseName;

  const ProgressChart({
    super.key,
    required this.sessions,
    required this.exerciseName,
  });

  @override
  Widget build(BuildContext context) {
    final spots = _generateSpots();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 4,
            color: Theme.of(context).primaryColor,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withAlpha(77),
            ),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final session = sessions.firstWhere(
                  (s) => s.startTime.millisecondsSinceEpoch == value.toInt(),
                );
                return Text(DateFormat.MMMd().format(session.startTime));
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  List<FlSpot> _generateSpots() {
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

      return FlSpot(
        session.startTime.millisecondsSinceEpoch.toDouble(),
        maxWeight.toDouble(),
      );
    }).toList();
  }
}
