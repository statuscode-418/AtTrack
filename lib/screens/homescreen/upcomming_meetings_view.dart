import 'package:flutter/material.dart';
import '../../components/eventcard.dart';
import '../../models/event_model.dart';

class UpcommingMeetingsView extends StatelessWidget {
  const UpcommingMeetingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: [
          const Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 30,
              color: Color(0xFF73FBFD),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              EventCard(
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
              EventCard(
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
        ],
      ),
    );
  }
}
