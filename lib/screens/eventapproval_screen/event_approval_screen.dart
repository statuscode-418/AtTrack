import 'package:attrack/screens/event_approval_user_details_screen/user_approval_screen.dart';
import 'package:flutter/material.dart';
import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/form_submission.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';

class EventApprovalScreen extends StatefulWidget {
  final DBModel db;
  final EventModel event;

  const EventApprovalScreen({
    super.key,
    required this.db,
    required this.event,
  });

  @override
  State<EventApprovalScreen> createState() => _EventApprovalScreenState();
}

class _EventApprovalScreenState extends State<EventApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Approval'),
      ),
      body: StreamBuilder<List<FormSubmission>>(
        stream: widget.db.getSubmissions(widget.event.eid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error : ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No submissions found'),
            );
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final submission = snapshot.data![index];
                return FutureBuilder<EventModel?>(
                  future: widget.db.getEvent(submission.eid),
                  builder: (context, eventSnapshot) {
                    if (eventSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const ListTile(
                        title: Text('Loading...'),
                      );
                    } else if (eventSnapshot.hasError) {
                      return ListTile(
                        title: Text('Error: ${eventSnapshot.error}'),
                      );
                    } else if (!eventSnapshot.hasData) {
                      return const ListTile(
                        title: Text('Event not found'),
                      );
                    } else {
                      final event = eventSnapshot.data!;
                      return FutureBuilder<UserModel?>(
                        future: widget.db.getUser(event.uid),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ListTile(
                              title: Text('Loading user...'),
                            );
                          } else if (userSnapshot.hasError) {
                            return ListTile(
                              title: Text('Error: ${userSnapshot.error}'),
                            );
                          } else if (!userSnapshot.hasData) {
                            return const ListTile(
                              title: Text('User not found'),
                            );
                          } else {
                            final user = userSnapshot.data!;
                            return ListTile(
                              title: Text(user.name),
                              trailing: submission.accepted
                                  ? const Text(
                                      "Accepted",
                                      style: TextStyle(color: Colors.green),
                                    )
                                  : const Text(
                                      'Yet to be approved',
                                      style: TextStyle(color: Colors.red),
                                    ),
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return UserApprovalScreen(
                                    user: user,
                                    submission: submission,
                                    db: widget.db,
                                  );
                                },
                              )),
                            );
                          }
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
