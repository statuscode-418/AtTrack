import 'package:attrack/models/model_constants.dart';

class EventModel {
  final String eid;
  final String uid;
  final String title;
  final String? description;
  final DateTime date;
  final DateTime deadline;
  final String city;
  final String address;
  final String? photoUrl;
  final String? website;
  final double latitude;
  final double longitude;

  final bool isOpenToAll;
  final bool isAutoEntry;

  final DateTime createdAt;
  final DateTime updatedAt;

  const EventModel({
    required this.eid,
    required this.uid,
    required this.title,
    required this.date,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.deadline,
    this.description,
    this.photoUrl,
    this.website,
    this.isOpenToAll = false,
    this.isAutoEntry = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      ModelConsts.eid: eid,
      ModelConsts.uid: uid,
      ModelConsts.title: title,
      ModelConsts.description: description,
      ModelConsts.date: date.toIso8601String(),
      ModelConsts.city: city,
      ModelConsts.address: address,
      ModelConsts.photoUrl: photoUrl,
      ModelConsts.website: website,
      ModelConsts.latitude: latitude,
      ModelConsts.longitude: longitude,
      ModelConsts.isOpenToAll: isOpenToAll,
      ModelConsts.isAutoEntry: isAutoEntry,
      ModelConsts.createdAt: createdAt.toIso8601String(),
      ModelConsts.updatedAt: updatedAt.toIso8601String(),
      ModelConsts.deadline: deadline.toIso8601String(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      eid: map[ModelConsts.eid],
      uid: map[ModelConsts.uid],
      title: map[ModelConsts.title],
      description: map[ModelConsts.description],
      date: DateTime.parse(map[ModelConsts.date]),
      city: map[ModelConsts.city],
      address: map[ModelConsts.address],
      photoUrl: map[ModelConsts.photoUrl],
      website: map[ModelConsts.website],
      latitude: map[ModelConsts.latitude],
      longitude: map[ModelConsts.longitude],
      isOpenToAll: map[ModelConsts.isOpenToAll],
      isAutoEntry: map[ModelConsts.isAutoEntry],
      createdAt: DateTime.parse(map[ModelConsts.createdAt]),
      updatedAt: DateTime.parse(map[ModelConsts.updatedAt]),
      deadline: DateTime.parse(map[ModelConsts.deadline]),
    );
  }

  factory EventModel.newEvent({
    required String uid,
    required String mid,
    required String title,
    String? description,
    required DateTime date,
    required String city,
    required String address,
    String? photoUrl,
    String? website,
    required double latitude,
    required double longitude,
    required DateTime deadline,
    bool isOpenToAll = false,
    bool isAutoEntry = false,
  }) {
    return EventModel(
      eid: mid,
      uid: uid,
      title: title,
      description: description,
      date: date,
      city: city,
      address: address,
      photoUrl: photoUrl,
      website: website,
      latitude: latitude,
      longitude: longitude,
      isOpenToAll: isOpenToAll,
      isAutoEntry: isAutoEntry,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      deadline: deadline,
    );
  }

  EventModel copyWith({
    String? eid,
    String? uid,
    String? title,
    String? description,
    DateTime? date,
    String? city,
    String? address,
    String? photoUrl,
    String? website,
    double? latitude,
    double? longitude,
    bool? isOpenToAll,
    bool? isAutoEntry,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deadline,
  }) {
    return EventModel(
      eid: eid ?? this.eid,
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      city: city ?? this.city,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      website: website ?? this.website,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isOpenToAll: isOpenToAll ?? this.isOpenToAll,
      isAutoEntry: isAutoEntry ?? this.isAutoEntry,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deadline: deadline ?? this.deadline,
    );
  }
}
