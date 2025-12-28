import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/badges.dart';
import '../models/badge.dart';

class BadgeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkAndAwardBadges() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDocRef = _firestore.collection('users').doc(user.uid);
    final userDoc = await userDocRef.get();
    final userData = userDoc.data() as Map<String, dynamic>?;

    if (userData == null) return;

    final completedWorkouts =
        (userData['completedWorkouts'] as List? ?? []).length;
    final earnedBadges = (userData['earnedBadges'] as List? ?? [])
        .cast<String>();

    for (final badge in badges) {
      if (!earnedBadges.contains(badge.id)) {
        if (_meetsCriteria(badge, completedWorkouts)) {
          await userDocRef.update({
            'earnedBadges': FieldValue.arrayUnion([badge.id]),
          });
        }
      }
    }
  }

  bool _meetsCriteria(Badge badge, int completedWorkouts) {
    switch (badge.id) {
      case 'first_workout':
        return completedWorkouts >= 1;
      case 'five_workouts':
        return completedWorkouts >= 5;
      case 'ten_workouts':
        return completedWorkouts >= 10;
      case 'twenty_workouts':
        return completedWorkouts >= 20;
      default:
        return false;
    }
  }
}
