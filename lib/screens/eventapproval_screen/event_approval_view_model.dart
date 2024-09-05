import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/form_submission.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class EventApprovalViewModel extends ChangeNotifier {
  final DBModel db;
  final String eventId;
  List<FormSubmission>? _submissions;
  StreamSubscription<List<FormSubmission>>? _submissionSubscription;

  EventApprovalViewModel({
    required this.db,
    required this.eventId,
  }) {
    _listenToSubmissions();
  }

  List<FormSubmission>? get submissions => _submissions;

  void _listenToSubmissions() {
    _submissionSubscription =
        db.getSubmissions(eventId).listen((submissionList) {
      _submissions = submissionList;
      notifyListeners();
    });
  }

  Future<EventModel?> getEvent(String eventId) => db.getEvent(eventId);

  Future<UserModel?> getUserByCode(String userCode) =>
      db.getUserbyUserCode(userCode);

  @override
  void dispose() {
    _submissionSubscription?.cancel();
    super.dispose();
  }
}
