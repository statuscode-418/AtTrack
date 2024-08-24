import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/form_field_answer.dart';
import 'package:attrack/models/form_field_model.dart';
import 'package:attrack/models/form_model.dart';
import 'package:attrack/models/form_submission.dart';
import 'package:attrack/models/model_constants.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_constants.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/services/firestore_storage/firestore_db_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDB implements DBModel {
  late final FirebaseFirestore _db;

  @override
  Future<void> init() async {
    _db = FirebaseFirestore.instance;
  }

  CollectionReference get userCollection => _db.collection(DBConstants.users);

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      await userCollection.doc(user.uid).set(user.toMap());
    } on FirebaseException {
      throw CouldNotCreateUserException();
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
    return user;
  }

  @override
  Future<void> deleteUser(String uid) async {
    try {
      await userCollection.doc(uid).delete();
    } on FirebaseException {
      throw CouldNotDeleteUserException();
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<UserModel?> getUser(String uid) async {
    try {
      var user = await userCollection.doc(uid).get();
      if (user.exists) {
        return UserModel.fromMap(user.data() as Map<String, dynamic>);
      }
      return null;
    } on FirebaseException {
      throw CouldNotGetUserException();
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      await userCollection.doc(user.uid).update(user.toMap());
    } on FirebaseException {
      throw CouldNotUpdateUserException();
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }

    return user;
  }

  CollectionReference get meetingCollection =>
      _db.collection(DBConstants.events);

  @override
  Future<void> createEvent(EventModel meeting) async {
    try {
      await meetingCollection.doc(meeting.eid).set(meeting.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not create meeting',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<void> deleteEvent(String meetingId) async {
    try {
      await meetingCollection.doc(meetingId).delete();
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not delete meeting',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<EventModel?> getEvent(String meetingId) async {
    try {
      var meeting = await meetingCollection.doc(meetingId).get();
      if (meeting.exists) {
        return EventModel.fromMap(meeting.data() as Map<String, dynamic>);
      }
      return null;
    } on FirebaseException {
      throw const FirestoreDBExceptions(
        message: 'Could not get meeting',
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Stream<List<EventModel>> getEvents() {
    try {
      return meetingCollection.snapshots().map((snapshot) {
        return snapshot.docs
            .map(
                (doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not get meetings',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Stream<List<EventModel>> getUpcomingEvents() {
    try {
      return meetingCollection
          .where(ModelConsts.deadline, isGreaterThanOrEqualTo: DateTime.now())
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map(
                (doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not get upcoming meetings',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Stream<List<EventModel>> getUserEvents(String uid) {
    try {
      return meetingCollection
          .where(ModelConsts.uid, isEqualTo: uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map(
                (doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not get user meetings',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<void> updateEvent(EventModel meeting) async {
    try {
      await meetingCollection.doc(meeting.eid).update(meeting.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not update meeting',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  CollectionReference get formCollection => _db.collection(DBConstants.forms);

  CollectionReference get fieldCollection =>
      _db.collection(DBConstants.formFields);

  @override
  Future<void> createForm(FormModel form) async {
    try {
      await formCollection.doc(form.fid).set(form.toMap());
      var tasks = form.fields.map((field) async {
        await fieldCollection.doc(field.id).set(field.toMap());
      });
      await Future.wait(tasks);
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not create form',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<void> deleteForm(String formId) async {
    try {
      var fields =
          await fieldCollection.where(ModelConsts.fid, isEqualTo: formId).get();
      var tasks = fields.docs.map((field) async {
        await field.reference.delete();
      });
      await Future.wait(tasks);
      await formCollection.doc(formId).delete();
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not delete form',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<FormModel?> getForm(String formId) async {
    try {
      var fields =
          await fieldCollection.where(ModelConsts.fid, isEqualTo: formId).get();
      var formFields = fields.docs.map((field) {
        return FormField.fromMap(field.data() as Map<String, dynamic>);
      }).toList();
      var form = await formCollection.doc(formId).get();
      if (form.exists) {
        return FormModel.fromMap(
            form.data() as Map<String, dynamic>, formFields);
      }
      return null;
    } on FirebaseException {
      throw const FirestoreDBExceptions(
        message: 'Could not get form',
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<void> updateForm(FormModel form) async {
    try {
      var fields = await fieldCollection
          .where(ModelConsts.fid, isEqualTo: form.fid)
          .get();
      var tasks = fields.docs.map((field) async {
        await field.reference.delete();
      });
      await Future.wait(tasks);
      tasks = form.fields.map((field) async {
        await fieldCollection.doc(field.id).set(field.toMap());
      });
      await formCollection.doc(form.fid).update(form.toMap());
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not update form',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<void> createSubmission(FormSubmission submission) async {
    try {
      await _db
          .collection(DBConstants.formSubmissions)
          .doc(submission.sid)
          .set(submission.toMap());
      var tasks = submission.answers.map((answer) async {
        await _db
            .collection(DBConstants.formSubmissions)
            .doc(submission.sid)
            .collection(DBConstants.formAnswers)
            .doc(answer.id)
            .set(answer.toMap());
      });
      await Future.wait(tasks);
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not create submission',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<void> deleteSubmission(String submissionId) async {
    try {
      var answers = await _db
          .collection(DBConstants.formSubmissions)
          .doc(submissionId)
          .collection(DBConstants.formAnswers)
          .get();
      var tasks = answers.docs.map((answer) async {
        await answer.reference.delete();
      });
      await Future.wait(tasks);
      await _db
          .collection(DBConstants.formSubmissions)
          .doc(submissionId)
          .delete();
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not delete submission',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<FormSubmission?> getSubmission(String submissionId) async {
    try {
      var formDoc = await _db
          .collection(DBConstants.formSubmissions)
          .doc(submissionId)
          .get();

      if (!formDoc.exists) {
        return null;
      }

      var answers = await _db
          .collection(DBConstants.formSubmissions)
          .doc(submissionId)
          .collection(DBConstants.formAnswers)
          .get();

      var formAnswers = answers.docs.map((answer) {
        return FieldAnswer.fromMap(answer.data());
      }).toList();

      return FormSubmission.fromMap(formDoc.data()!, formAnswers);
    } on FirebaseException {
      throw const FirestoreDBExceptions(
        message: 'Could not get submission',
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Stream<List<FormSubmission>> getSubmissions(String eid) {
    try {
      return _db
          .collection(DBConstants.formSubmissions)
          .where(ModelConsts.eid, isEqualTo: eid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return FormSubmission.fromMap(doc.data(), []);
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not get submissions',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }

  @override
  Future<List<FieldAnswer>> getFormAnswers(String sid) async {
    try {
      var answers = await _db
          .collection(DBConstants.formSubmissions)
          .doc(sid)
          .collection(DBConstants.formAnswers)
          .get();
      return answers.docs.map((answer) {
        return FieldAnswer.fromMap(answer.data());
      }).toList();
    } on FirebaseException catch (e) {
      throw FirestoreDBExceptions(
        message: 'Could not get form answers',
        details: e.toString(),
      );
    } on Exception catch (e) {
      throw GenericDbException(e.toString());
    }
  }
}
