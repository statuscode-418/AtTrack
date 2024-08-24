import 'model_constants.dart';

class CheckpointStamp {
  final String stampId;
  final String participantCode;
  final String checkpointId;
  final String eventId;
  final String uid;

  final DateTime createdAt;

  const CheckpointStamp({
    required this.stampId,
    required this.participantCode,
    required this.checkpointId,
    required this.eventId,
    required this.uid,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      ModelConsts.stampId: stampId,
      ModelConsts.participantCode: participantCode,
      ModelConsts.checkpointId: checkpointId,
      ModelConsts.eventId: eventId,
      ModelConsts.uid: uid,
      ModelConsts.createdAt: createdAt.toIso8601String(),
    };
  }

  factory CheckpointStamp.fromMap(Map<String, dynamic> map) {
    return CheckpointStamp(
      stampId: map[ModelConsts.stampId],
      participantCode: map[ModelConsts.participantCode],
      checkpointId: map[ModelConsts.checkpointId],
      eventId: map[ModelConsts.eventId],
      uid: map[ModelConsts.uid],
      createdAt: DateTime.parse(map[ModelConsts.createdAt]),
    );
  }
}
