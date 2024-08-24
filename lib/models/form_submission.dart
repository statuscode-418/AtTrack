import 'package:attrack/models/model_constants.dart';

import 'form_field_answer.dart';

class FormSubmission {
  final String sid;
  final String fid;
  final String userCode;
  final String eid;

  final DateTime submittedAt;
  final List<FieldAnswer> answers;

  const FormSubmission({
    required this.sid,
    required this.fid,
    required this.userCode,
    required this.eid,
    required this.submittedAt,
    required this.answers,
  });

  Map<String, dynamic> toMap() {
    return {
      ModelConsts.sid: sid,
      ModelConsts.fid: fid,
      ModelConsts.uniqueCode: userCode,
      ModelConsts.eid: eid,
      ModelConsts.submittedAt: submittedAt.toIso8601String(),
    };
  }

  factory FormSubmission.fromMap(
      Map<String, dynamic> map, List<FieldAnswer> answers) {
    return FormSubmission(
      sid: map[ModelConsts.sid],
      fid: map[ModelConsts.fid],
      userCode: map[ModelConsts.uniqueCode],
      eid: map[ModelConsts.eid],
      submittedAt: DateTime.parse(map[ModelConsts.submittedAt]),
      answers: answers,
    );
  }
}
