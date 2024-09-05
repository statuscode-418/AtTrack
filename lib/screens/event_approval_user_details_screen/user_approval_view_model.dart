import 'package:attrack/models/form_submission.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/foundation.dart';

class UserApprovalViewModel extends ChangeNotifier {
  final UserModel user;
  final FormSubmission submission;
  final DBModel db;

  UserApprovalViewModel({
    required this.user,
    required this.submission,
    required this.db,
  });

  void disapproveUser() {
    var newSubmission = submission.copyWith(accepted: false);
    db.updateSubmission(newSubmission).then((_) {
      submission.accepted = newSubmission.accepted;
      notifyListeners();
    });
  }

  void approveUser() {
    var newSubmission = submission.copyWith(accepted: true);
    db.updateSubmission(newSubmission).then((_) {
      submission.accepted = newSubmission.accepted;
      notifyListeners();
    });
  }
}
