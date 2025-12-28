import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/social_event_model.dart';

class SocialEventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<SocialEvent> _socialEvents = [];

  List<SocialEvent> get socialEvents => _socialEvents;

  SocialEventProvider() {
    _fetchSocialEvents();
  }

  Future<void> _fetchSocialEvents() async {
    try {
      final snapshot = await _firestore.collection('social_events').get();
      _socialEvents.clear();
      for (var doc in snapshot.docs) {
        _socialEvents.add(SocialEvent.fromFirestore(doc));
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching social events: $e');
    }
  }

  Future<void> joinEvent(String eventId, String userId) async {
    try {
      await _firestore.collection('social_events').doc(eventId).update({
        'participants': FieldValue.arrayUnion([userId]),
      });
      _fetchSocialEvents();
    } catch (e) {
      print('Error joining event: $e');
    }
  }
}
