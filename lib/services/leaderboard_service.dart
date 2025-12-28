import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot>> getLeaderboard() async {
    final snapshot = await _firestore
        .collection('users')
        .orderBy('completedWorkouts', descending: true)
        .limit(100) // Get the top 100 users
        .get();
    return snapshot.docs;
  }
}
