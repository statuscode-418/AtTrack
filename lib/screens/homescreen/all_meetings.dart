import 'package:attrack/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../components/eventcard.dart';

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
      child: Container(
        child: Column(
          children: [
            ListView(
              children: const [
                Text(
                  'Event History',
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
            ElevatedButton(
                onPressed: () {}, child: const Text('Create Meeting'))
          ],
        ),
      ),
    );
  }
}
