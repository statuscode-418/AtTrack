import 'model_constants.dart';

class CheckpointModel {
  final String checkpointId;
  final String name;
  final String description;
  final String eventId;
  final DateTime createdAt;

  final DateTime? start;
  final DateTime? end;

  final double? latitude;
  final double? longitude;

  const CheckpointModel({
    required this.checkpointId,
    required this.name,
    required this.description,
    required this.eventId,
    required this.createdAt,
    this.start,
    this.end,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      ModelConsts.checkpointId: checkpointId,
      ModelConsts.name: name,
      ModelConsts.description: description,
      ModelConsts.eventId: eventId,
      ModelConsts.createdAt: createdAt.toIso8601String(),
      ModelConsts.start: start?.toIso8601String(),
      ModelConsts.end: end?.toIso8601String(),
      ModelConsts.latitude: latitude,
      ModelConsts.longitude: longitude,
    };
  }

  factory CheckpointModel.fromMap(Map<String, dynamic> map) {
    return CheckpointModel(
      checkpointId: map[ModelConsts.checkpointId],
      name: map[ModelConsts.name],
      description: map[ModelConsts.description],
      eventId: map[ModelConsts.eventId],
      createdAt: DateTime.parse(map[ModelConsts.createdAt]),
      start: map[ModelConsts.start] != null
          ? DateTime.parse(map[ModelConsts.start])
          : null,
      end: map[ModelConsts.end] != null
          ? DateTime.parse(map[ModelConsts.end])
          : null,
      latitude: map[ModelConsts.latitude],
      longitude: map[ModelConsts.longitude],
    );
  }
}
