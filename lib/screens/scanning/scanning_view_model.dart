import 'package:attrack/models/checkpoint_model.dart';
import 'package:attrack/models/checkpoint_stamp.dart';
import 'package:attrack/models/event_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/services/firestore_storage/firestore_db_exceptions.dart';
import 'package:attrack/services/qr_service/qr_parser.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ScanningViewModel extends ChangeNotifier {
  final CheckpointModel checkpointModel;
  final EventModel eventModel;
  final DBModel db;

  ScanningViewModel({
    required this.checkpointModel,
    required this.eventModel,
    required this.db,
  });

  Future<void> processScan(String raw) async {
    try {
      String participantCode = QrParser.parseHost(raw);
      var stampId = const Uuid().v4();
      var checkpointStamp = CheckpointStamp(
        stampId: stampId,
        participantCode: participantCode,
        checkpointId: checkpointModel.checkpointId,
        eventId: checkpointModel.eventId,
        uid: eventModel.uid,
        createdAt: DateTime.now(),
      );

      await db.createCheckpointStamp(checkpointStamp);
    } catch (e) {
      throw GenericDbException(e.toString());
    }
  }
}
