import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/eventdetails_screen/eventdetails_body.dart';
import 'package:attrack/screens/eventdetails_screen/eventdetails_provider.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModifiedEventDetailsScreen extends StatelessWidget {
  final EventModel event;
  final UserModel user;
  final DBModel db;

  const ModifiedEventDetailsScreen({
    super.key,
    required this.event,
    required this.user,
    required this.db,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          EventDetailsProvider(event: event, user: user, db: db),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Event Details'),
        ),
        body: const EventDetailsBody(),
      ),
    );
  }
}
