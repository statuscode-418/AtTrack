import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/create_event_screen/create_event_screen.dart';
import 'package:attrack/screens/eventdetails_screen/eventdetails_screen.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';
import '../../components/eventcard.dart';
import '../../models/event_model.dart';

class PastEvents extends StatelessWidget {
  final UserModel user;
  final DBModel db;

  const PastEvents({
    super.key,
    required this.user,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: StreamBuilder<List<EventModel>>(
                stream: db.getEvents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error : $snapshot.error'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No events found'),
                    );
                  } else {
                    final events = snapshot.data;
                    return ListView.builder(
                      itemCount: events?.length,
                      itemBuilder: (context, index) {
                        final event = events?[index];
                        return EventCard(
                          user: user,
                          event: event!,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EventDetailsScreen(
                                  event: event,
                                  user: user,
                                  db: db,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                }),
          ),
          if (user.isAdmin)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateEventScreen(
                        uid: user.uid,
                        db: db,
                      ),
                    ),
                  );
                },
                child: const Text('Create Meeting'),
              ),
            ),
        ],
      ),
    );
  }
}
