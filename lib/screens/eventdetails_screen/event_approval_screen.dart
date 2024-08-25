import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/form_submission.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EventApprovalScreen extends StatefulWidget {
  final DBModel db;
  EventModel event;

  EventApprovalScreen({
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
                  child: Text('Error : $snapshot.error'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No events found'),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final submision = snapshot.data![index];
                      return ListTile(
                        title: Text(submision.sid),
                        trailing: submision.accepted
                            ? const Text(
                                "Accepted",
                                style: TextStyle(color: Colors.green),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  var newSubmission = submision.copyWith(
                                    accepted: true,
                                  );
                                  await widget.db
                                      .updateSubmission(newSubmission);
                                },
                                child: const Text('Approve'),
                              ),
                      );
                    });
              }
            }));
  }
}
