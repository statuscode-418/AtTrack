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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Past Events',
            style: TextStyle(
              fontSize: 30,
              color: Color(0xFF73FBFD),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          StreamBuilder<List<EventModel>>(
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
                  return Expanded(
                    child: ListView.builder(
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
                    ),
                  );
                }
              }),
          if (user.isAdmin)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                    ),
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
                    child: const Text(
                      'Create Meeting',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
