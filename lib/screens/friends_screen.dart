import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/friends_service.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _searchResults = [];

  void _searchUsers() async {
    final results = await context.read<FriendsService>().searchUsers(
      _searchController.text,
    );
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Scaffold(
        body: Center(
          child: Text('You need to be logged in to see your friends.'),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.group), text: 'Friends'),
              Tab(icon: Icon(Icons.person_add), text: 'Requests'),
              Tab(icon: Icon(Icons.search), text: 'Add Friends'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFriendsList(userId),
            _buildFriendRequestsList(userId),
            _buildAddFriendsTab(userId),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendsList(String userId) {
    final friendsService = context.read<FriendsService>();
    return StreamBuilder<List<String>>(
      stream: friendsService.getFriends(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('You have no friends yet.'));
        }

        final friendIds = snapshot.data!;
        return ListView.builder(
          itemCount: friendIds.length,
          itemBuilder: (context, index) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(friendIds[index])
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const ListTile(title: Text('Loading...'));
                }
                final friendData = userSnapshot.data!;
                return ListTile(
                  title: Text(friendData['name'] ?? 'N/A'),
                  subtitle: Text(friendData['email'] ?? 'N/A'),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFriendRequestsList(String userId) {
    final friendsService = context.read<FriendsService>();
    return StreamBuilder<List<String>>(
      stream: friendsService.getFriendRequests(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No new friend requests.'));
        }

        final requestIds = snapshot.data!;
        return ListView.builder(
          itemCount: requestIds.length,
          itemBuilder: (context, index) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(requestIds[index])
                  .get(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) {
                  return const ListTile(title: Text('Loading...'));
                }
                final requestorData = userSnapshot.data!;
                return ListTile(
                  title: Text(requestorData['name'] ?? 'N/A'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          friendsService.acceptFriendRequest(
                            userId: userId,
                            friendId: requestIds[index],
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          friendsService.declineFriendRequest(
                            userId: userId,
                            friendId: requestIds[index],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAddFriendsTab(String userId) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search for users by name',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _searchUsers,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                return ListTile(
                  title: Text(user['name'] ?? 'N/A'),
                  subtitle: Text(user['email'] ?? 'N/A'),
                  trailing: ElevatedButton(
                    child: const Text('Send Request'),
                    onPressed: () {
                      context.read<FriendsService>().sendFriendRequest(
                        senderId: userId,
                        recipientId: user.id,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
