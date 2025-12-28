import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/badges.dart';
import '../models/badge.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import '../services/progress_service.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context);
    final progressService = Provider.of<ProgressService>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go('/edit-profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const NetworkImage(
                      'https://www.shareicon.net/data/512x512/2016/08/18/813844_people_512x512.png',
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              user?.displayName ?? 'N/A',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              user?.email ?? 'N/A',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Workouts Completed'),
              trailing: Text(progressService.completedWorkouts.toString()),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Workout History'),
              onTap: () {
                context.go('/workout-history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Friends'),
              onTap: () {
                context.go('/friends');
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Points Earned'),
              trailing: Text(progressService.totalPoints.toString()),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Achievements',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildBadgeGrid(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                context.go('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await authService.signOut();
                if (context.mounted) {
                  context.go('/');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeGrid() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final userData = snapshot.data!.data() as Map<String, dynamic>?;
        final earnedBadgeIds = (userData?['earnedBadges'] as List? ?? [])
            .cast<String>();

        final earnedBadges = badges
            .where((badge) => earnedBadgeIds.contains(badge.id))
            .toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: earnedBadges.length,
          itemBuilder: (context, index) {
            final badge = earnedBadges[index];
            return Tooltip(
              message: '${badge.name}\n${badge.description}',
              child: CircleAvatar(
                backgroundColor: badge.color,
                child: Icon(badge.icon, color: Colors.white),
              ),
            );
          },
        );
      },
    );
  }
}
