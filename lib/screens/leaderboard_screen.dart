import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/leaderboard_service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardService = context.read<LeaderboardService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: leaderboardService.getLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No users on the leaderboard yet.'),
            );
          }

          final leaderboard = snapshot.data!;

          return ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final user = leaderboard[index].data() as Map<String, dynamic>;
              final rank = index + 1;

              return ListTile(
                leading: CircleAvatar(child: Text(rank.toString())),
                title: Text(user['name'] ?? 'N/A'),
                subtitle: Text('Workouts: ${user['completedWorkouts'] ?? 0}'),
              );
            },
          );
        },
      ),
    );
  }
}
