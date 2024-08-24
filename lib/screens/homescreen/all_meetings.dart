import 'package:flutter/material.dart';
import '../../components/eventcard.dart';

class AllMeetings extends StatelessWidget {
  const AllMeetings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        children: const [
          Text(
            'Registered Events',
            style: TextStyle(
              fontSize: 30,
              color: Color(0xFF73FBFD),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          EventCard(
            imageUrl: 'https://via.placeholder.com/100',
            heading: 'Diversion',
            subheading: '36 hour Hackathon',
            date: 'Saturday 04 February',
            location: 'IEM Kolkata',
          ),
        ],
      ),
    );
  }
}
