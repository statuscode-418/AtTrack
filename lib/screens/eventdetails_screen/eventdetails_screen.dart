import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/eventdetails_screen/event_approval_screen.dart';
import 'package:attrack/screens/userform/user_form.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;
  final UserModel user;
  final DBModel db;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.user,
    required this.db,
  });

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  void _joinEvent() async {
    var form = await widget.db.getFormByEvent(widget.event.eid);
    if (form == null) {
      return;
    }
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return UserForm(
          form: form,
          user: widget.user,
          db: widget.db,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: widget.event.photoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(widget.event.photoUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey[300],
                  ),
                  child: widget.event.photoUrl == null
                      ? Center(
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[800],
                            size: 50,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget.event.title,
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF73FBFD),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8.0),
                    Text(
                      widget.event.date.toString(),
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(width: 8.0),
                    Text(widget.event.address,
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text('Description',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF73FBFD))),
                Text(
                  widget.event.description ?? '',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 16.0),
                const Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  children: [
                    Chip(
                      label: Text('Entry'),
                    ),
                    Chip(
                      label: Text('Lunch'),
                    ),
                    Chip(
                      label: Text('Dinner'),
                    ),
                    Chip(
                      label: Text('Exit'),
                    ),
                  ],
                ),
                const SizedBox(height: 80.0),
                if (widget.user.isAdmin && widget.user.uid == widget.event.uid)
                  Container(
                    color: const Color(0xFF322C2C),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Approval',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Approval Required',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Your registration is subject to approval by the host.',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        ),
                        const Text(
                          'Welcome! To join the event, please register below',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your onPressed code here!
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return EventApprovalScreen(
                                    db: widget.db,
                                    event: widget.event,
                                  );
                                },
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                            ),
                            child: const Text(
                              'Approve Registration',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    color: const Color(0xFF322C2C),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Registration',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Approval Required',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Your registration is subject to approval by the host.',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 1.0,
                        ),
                        const Text(
                          'Welcome! To join the event, please register below',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Center(
                          child: ElevatedButton(
                            onPressed: _joinEvent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                            ),
                            child: const Text(
                              'Request to Join',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 80.0),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF322C2C),
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                enableSuggestions: false,
                autocorrect: false,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  label: Text('Ask your doubts here',
                      style: TextStyle(color: Colors.white)),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  suffixIcon:
                      Icon(Icons.question_answer_outlined, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
