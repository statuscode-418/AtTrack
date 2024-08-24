import 'package:attrack/models/model_constants.dart';
import 'package:attrack/models/app_model.dart';

class UserModel implements AppModel {
  final String uid;
  final String uniqueCode;
  final String name;
  final String email;
  final String? photoUrl;
  final String github;
  final String linkedin;
  final String instagram;
  final String phoneNumber;
  final List<String> eventIds;

  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.github,
    required this.linkedin,
    required this.phoneNumber,
    required this.instagram,
    required this.name,
    required this.uniqueCode,
    required this.createdAt,
    required this.updatedAt,
    this.eventIds = const [],
    this.photoUrl,
  });

  UserModel.newUser({
    required this.uid,
    required this.email,
    required this.uniqueCode,
  })  : name = '',
        linkedin = '',
        instagram = '',
        phoneNumber = '',
        photoUrl = null,
        github = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now(),
        eventIds = const [];

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    String? github,
    String? linkedin,
    String? instagram,
    String? phoneNumber,
    String? uniqueCode,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      github: github ?? this.github,
      linkedin: linkedin ?? this.linkedin,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      instagram: instagram ?? this.instagram,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      uniqueCode: uniqueCode ?? this.uniqueCode,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ModelConsts.uid: uid,
      ModelConsts.name: name,
      ModelConsts.photoUrl: photoUrl,
      ModelConsts.instagram: instagram,
      ModelConsts.github: github,
      ModelConsts.linkedin: linkedin,
      ModelConsts.phoneNumber: phoneNumber,
      ModelConsts.email: email,
      ModelConsts.uniqueCode: uniqueCode,
      ModelConsts.createdAt: createdAt.toIso8601String(),
      ModelConsts.updatedAt: updatedAt.toIso8601String(),
      ModelConsts.eventIds: eventIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map[ModelConsts.uid],
      name: map[ModelConsts.name],
      photoUrl: map[ModelConsts.photoUrl],
      instagram: map[ModelConsts.instagram],
      github: map[ModelConsts.github],
      linkedin: map[ModelConsts.linkedin],
      phoneNumber: map[ModelConsts.phoneNumber],
      email: map[ModelConsts.email],
      uniqueCode: map[ModelConsts.uniqueCode],
      createdAt: DateTime.parse(map[ModelConsts.createdAt]),
      updatedAt: DateTime.parse(map[ModelConsts.updatedAt]),
      eventIds: List<String>.from(map[ModelConsts.eventIds] ?? []),
    );
  }
}
