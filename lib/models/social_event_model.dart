import 'package:cloud_firestore/cloud_firestore.dart';

class SocialEvent {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final List<String> participants;

  SocialEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.participants,
  });

  factory SocialEvent.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return SocialEvent(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      location: data['location'] ?? '',
      participants: List<String>.from(data['participants'] ?? []),
    );
  }
}
