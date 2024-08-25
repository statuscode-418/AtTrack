import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/create_event_screen/create_event_screen.dart';
import 'package:flutter/material.dart';
import '../../components/eventcard.dart';
import '../../models/event_model.dart';

class AllMeetings extends StatelessWidget {
  final UserModel user;
  const AllMeetings({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: ListView(
              children: [
                const Text(
                  'Event History',
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF73FBFD),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                EventCard(
                  user: user,
                  event: EventModel.newEvent(
                    uid: '1bd',
                    mid: 'hello',
                    title: 'Hack4Bengal',
                    date: DateTime.now(),
                    city: 'Kolkata',
                    address: 'kolkata',
                    latitude: 12,
                    longitude: 24,
                    deadline: DateTime.now(),
                  ),
                ), 
              ],
            ),
          ),
          if (user.isAdmin)
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CreateEventScreen(),
                      ));
                    },
                    child: const Text('Create Meeting')))
        ],
      ),
    );
  }
}
