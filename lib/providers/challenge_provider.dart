import 'package:flutter/material.dart';
import 'package:myapp/models/challenge_model.dart';

class ChallengeProvider with ChangeNotifier {
  final List<Challenge> _challenges = [
    Challenge(
      id: '1',
      title: '30-Day Fitness Challenge',
      description: 'Complete a workout every day for 30 days.',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      participants: [],
    ),
    Challenge(
      id: '2',
      title: 'Run a 5K',
      description: 'Train for and run a 5K.',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 60)),
      participants: [],
    ),
  ];

  List<Challenge> get challenges => _challenges;

  void joinChallenge(String challengeId, String userId) {
    final challenge = _challenges.firstWhere((c) => c.id == challengeId);
    challenge.participants.add(userId);
    notifyListeners();
  }
}
