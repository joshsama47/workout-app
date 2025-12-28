import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a friend request
  Future<void> sendFriendRequest({
    required String senderId,
    required String recipientId,
  }) async {
    // Add to recipient's friend requests
    await _firestore
        .collection('users')
        .doc(recipientId)
        .collection('friend_requests')
        .doc(senderId)
        .set({'timestamp': FieldValue.serverTimestamp()});
  }

  // Accept a friend request
  Future<void> acceptFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    // Add to each other's friends list
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .set({});
    await _firestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(userId)
        .set({});

    // Remove the request
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('friend_requests')
        .doc(friendId)
        .delete();
  }

  // Decline a friend request
  Future<void> declineFriendRequest({
    required String userId,
    required String friendId,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('friend_requests')
        .doc(friendId)
        .delete();
  }

  // Get a stream of a user's friends
  Stream<List<String>> getFriends(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Get a stream of a user's friend requests
  Stream<List<String>> getFriendRequests(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friend_requests')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  // Search for users by name
  Future<List<QueryDocumentSnapshot>> searchUsers(String query) async {
    if (query.isEmpty) {
      return [];
    }
    final snapshot = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '${query}z')
        .limit(10)
        .get();
    return snapshot.docs;
  }
}
