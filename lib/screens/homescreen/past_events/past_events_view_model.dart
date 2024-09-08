import 'dart:async';

import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/create_event_screen/create_event_screen.dart';
import 'package:attrack/screens/eventdetails_screen/eventdetails_screen.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';

class PastEventsViewModel extends ChangeNotifier {
  final UserModel user;
  final DBModel db;
  List<EventModel>? _events;
  StreamSubscription<List<EventModel>>? _eventsSubscription;

  PastEventsViewModel({
    required this.user,
    required this.db,
  }) {
    _subscribeToEvents();
  }

  List<EventModel>? get events => _events;

  void _subscribeToEvents() {
    _eventsSubscription = db.getEvents().listen((events) {
      _events = events;
      notifyListeners();
    });
  }

  bool get isAdmin => user.isAdmin;

  void navigateToEventDetails(BuildContext context, EventModel event) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EventDetailsScreen(
        event: event,
        user: user,
        db: db,
      ),
    ));
  }

  void navigateToCreateEvent(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CreateEventScreen(db: db, uid: user.uid),
    ));
  }

  @override
  void dispose() {
    _eventsSubscription?.cancel();
    super.dispose();
  }
}
