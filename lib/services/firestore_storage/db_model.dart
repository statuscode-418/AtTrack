import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/form_model.dart';
import 'package:attrack/models/user_model.dart';

abstract class DBModel {
  Future<void> init();

  Future<UserModel> createUser(UserModel user);

  Future<UserModel?> getUser(String uid);

  Future<void> deleteUser(String uid);

  Future<UserModel> updateUser(UserModel user);

  Future<void> createEvent(EventModel event);

  Future<void> deleteEvent(String eventId);

  Future<EventModel?> getEvent(String eventId);

  Future<void> updateEvent(EventModel event);

  Stream<List<EventModel>> getEvents();

  Stream<List<EventModel>> getUserEvents(String uid);

  Stream<List<EventModel>> getUpcomingEvents();

  Future<void> createForm(FormModel form);

  Future<void> deleteForm(String formId);

  Future<FormModel?> getForm(String formId);

  Future<void> updateForm(FormModel form);
}
