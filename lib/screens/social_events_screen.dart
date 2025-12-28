import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/social_event_provider.dart';
import 'package:myapp/providers/user_provider.dart';

class SocialEventsScreen extends StatelessWidget {
  const SocialEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Events')),
      body: Consumer<SocialEventProvider>(
        builder: (context, eventProvider, child) {
          final user = Provider.of<UserProvider>(context).user;
          if (user == null) {
            return const Center(
              child: Text('Please log in to see social events.'),
            );
          }

          if (eventProvider.socialEvents.isEmpty) {
            return const Center(
              child: Text('No social events available at the moment.'),
            );
          }

          return ListView.builder(
            itemCount: eventProvider.socialEvents.length,
            itemBuilder: (context, index) {
              final event = eventProvider.socialEvents[index];
              final isParticipant = event.participants.contains(user.uid);

              return Card(
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(event.description),
                      const SizedBox(height: 8.0),
                      Text(
                        'Date: ${event.date.day}/${event.date.month}/${event.date.year}',
                      ),
                      const SizedBox(height: 8.0),
                      Text('Location: ${event.location}'),
                      const SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: isParticipant
                              ? null
                              : () {
                                  eventProvider.joinEvent(event.id, user.uid);
                                },
                          child: Text(isParticipant ? 'Joined' : 'Join Event'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
