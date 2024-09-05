import 'package:attrack/models/checkpoint_model.dart';
import 'package:attrack/models/event_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/foundation.dart';

class ScanningViewModel extends ChangeNotifier {
  final CheckpointModel checkpointModel;
  final EventModel eventModel;
  final DBModel db;

  ScanningViewModel({
    required this.checkpointModel,
    required this.eventModel,
    required this.db,
  });
}
