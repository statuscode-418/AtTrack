import 'package:flutter/material.dart';
import '../../components/eventcard.dart';

class UpcommingMeetingsView extends StatelessWidget {
  const UpcommingMeetingsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: const [
          Text(
            'Upcoming Events',
            style: TextStyle(
              fontSize: 30,
              color: Color(0xFF73FBFD),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          EventCard(
            imageUrl: 'https://via.placeholder.com/100',
            heading: 'Status Code 1',
            subheading: '36 hour Hackathon',
            date: 'Saturday 24 August',
            location: 'IISER Kolkata',
          ),
          EventCard(
            imageUrl: 'https://via.placeholder.com/100',
            heading: 'Hack 4 Bengal',
            subheading: '36 hour Hackathon',
            date: 'Thursday 29 August',
            location: 'JIS Kalyani',
          ),
        ],
      ),
    );
  }
}
