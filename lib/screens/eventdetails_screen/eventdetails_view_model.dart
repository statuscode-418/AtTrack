// ignore_for_file: use_build_context_synchronously

import 'package:attrack/models/checkpoint_model.dart';
import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/eventapproval_screen/event_approval_screen.dart';
import 'package:attrack/screens/scanning/scanning_screen.dart';
import 'package:attrack/screens/userform/user_form.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/services/firestore_storage/firestore_db_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class EventDetailsViewModel extends ChangeNotifier {
  final EventModel event;
  final UserModel user;
  final DBModel db;

  EventDetailsViewModel({
    required this.event,
    required this.user,
    required this.db,
  });

  Stream<List<CheckpointModel>> getCheckpoints() {
    return db.getCheckpoints(event.eid);
  }

  void onCheckpointTap(BuildContext context, CheckpointModel checkPoint) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return ScanningScreen(
            checkpointModel: checkPoint, eventModel: event, db: db);
      },
    ));
  }

  Future<void> deleteCheckpoint(
      BuildContext context, String checkpointId) async {
    try {
      await db.deleteCheckpoint(checkpointId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Checkpoint deleted successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting checkpoint: $e'),
        ),
      );
    }
  }

  Future<Map<String, String>?> _showAddChipDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return showDialog<Map<String, String>?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter label'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Checkpoint name'),
              ),
              TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(hintText: 'Enter description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'name': nameController.text,
                  'description': descriptionController.text,
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> addChip(BuildContext context) async {
    var result = await _showAddChipDialog(context);
    if (result != null && result.isNotEmpty) {
      var checkpointID = const Uuid();
      var checkPoint = CheckpointModel(
        checkpointId: checkpointID.v4(),
        name: result['name']!,
        description: result['description']!,
        eventId: event.eid,
        createdAt: DateTime.now(),
      );

      try {
        await db.createCheckpoint(checkPoint);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create checkpoint: $e')),
        );
        throw GenericDbException(e.toString());
      }
    }
    notifyListeners();
  }

  void navigateToApprovalScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return EventApprovalScreen(
          db: db,
          event: event,
        );
      },
    ));
  }

  Future<void> joinEvent(BuildContext context) async {
    var form = await db.getFormByEvent(event.eid);
    if (form == null) {
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return UserForm(
          form: form,
          user: user,
          db: db,
        );
      },
    ));
    notifyListeners();
  }
}
