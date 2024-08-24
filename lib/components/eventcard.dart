import 'package:attrack/models/event_model.dart';
import 'package:attrack/screens/eventdetails_screen/eventdetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    var format = DateFormat('dd-MM-yyyy');
    return GestureDetector(
      onTap: (){
        EventDetailsScreen(event: event);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsScreen(
              event: event,
            ),
          ),
        );
      },
      child: Card(
        color: const Color(0xFF322C2C),
         margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Color(0xFF73FBFD),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      event.description ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Date: ${format.format(event.date)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      event.address,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 120,
                height: 120,
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: event.photoUrl != null ?  DecorationImage(
                    image: NetworkImage(event.photoUrl!),
                    fit: BoxFit.cover,
                  ) : null,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey[300],
                ),
                child: event.photoUrl == null
                    ?  Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[800],
                          size: 50,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}