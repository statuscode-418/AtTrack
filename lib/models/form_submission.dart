import 'form_field_answer.dart';
import 'model_constants.dart';

class FormSubmission {
  final String sid;
  final String fid;
  final String userCode;
  final String eid;

  final DateTime submittedAt;
  bool accepted;
  final List<FieldAnswer> answers;

  FormSubmission({
    required this.sid,
    required this.fid,
    required this.userCode,
    required this.eid,
    required this.submittedAt,
    required this.answers,
    this.accepted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      ModelConsts.sid: sid,
      ModelConsts.fid: fid,
      ModelConsts.uniqueCode: userCode,
      ModelConsts.eid: eid,
      ModelConsts.submittedAt: submittedAt.toIso8601String(),
      ModelConsts.accepted: accepted,
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
      accepted: map[ModelConsts.accepted],
      answers: answers,
    );
  }

  FormSubmission copyWith({
    String? sid,
    String? fid,
    String? userCode,
    String? eid,
    DateTime? submittedAt,
    bool? accepted,
    List<FieldAnswer>? answers,
  }) {
    return FormSubmission(
      sid: sid ?? this.sid,
      fid: fid ?? this.fid,
      userCode: userCode ?? this.userCode,
      eid: eid ?? this.eid,
      submittedAt: submittedAt ?? this.submittedAt,
      accepted: accepted ?? this.accepted,
      answers: answers ?? this.answers,
    );
  }
}
