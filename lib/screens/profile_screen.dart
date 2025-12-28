import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/personal_record.dart';
import 'package:myapp/models/workout_session.dart';
import 'package:myapp/services/personal_record_service.dart';
import 'package:myapp/services/workout_service.dart';
import 'package:myapp/widgets/personal_record_card.dart';
import 'package:myapp/widgets/progress_chart.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final personalRecordService = PersonalRecordService();
    final workoutService = WorkoutService();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 30),
              onPressed: () => context.go('/settings'),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 100),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Text(
                        user?.displayName?[0] ?? 'U',
                        style: TextStyle(
                          fontSize: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user?.displayName ?? 'User',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('Workouts', '12'),
                        FutureBuilder<int>(
                          future: workoutService.getWorkoutStreak(
                            user?.uid ?? '',
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildStatItem('Streak', '-');
                            }
                            if (snapshot.hasError) {
                              return _buildStatItem('Streak', '0');
                            }
                            return _buildStatItem(
                              'Streak',
                              '${snapshot.data} days',
                            );
                          },
                        ),
                        _buildStatItem('Trophies', '3'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Progress',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200,
                child: FutureBuilder<List<WorkoutSession>>(
                  future: workoutService.getWorkoutHistoryForChart(
                    user?.uid ?? '',
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No workout history yet.'),
                      );
                    }
                    final sessions = snapshot.data!;
                    return ProgressChart(
                      sessions: sessions,
                      exerciseName: 'Bench Press',
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Personal Records',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: FutureBuilder<List<PersonalRecord>>(
                  future: personalRecordService.getPersonalRecords(
                    user?.uid ?? '',
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No personal records yet.'),
                      );
                    }
                    final records = snapshot.data!;
                    return ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        return PersonalRecordCard(record: records[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
