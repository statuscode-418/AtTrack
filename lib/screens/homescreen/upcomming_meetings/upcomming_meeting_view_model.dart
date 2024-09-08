import 'dart:async';

import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';

class UpcommingMeetingViewModel extends ChangeNotifier {
  UserModel user;
  final DBModel db;
  List<EventModel>? _events;
  StreamSubscription<List<EventModel>>? eventsSubscription;

  UpcommingMeetingViewModel({
    required this.db,
    required this.user,
  }) {
    _subscribeToEvents();
  }

  void _subscribeToEvents() {
    eventsSubscription = db.getUpcomingEvents().listen((events) {
      _events = events;
      notifyListeners();
    });
  }

  List<EventModel>? get events => _events;

  @override
  void dispose() {
    eventsSubscription?.cancel();
    super.dispose();
  }
}
