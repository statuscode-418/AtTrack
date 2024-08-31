// ignore_for_file: use_build_context_synchronously

import 'package:attrack/screens/userform/user_form.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:attrack/models/checkpoint_model.dart';
import 'package:attrack/models/event_model.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/services/firestore_storage/firestore_db_exceptions.dart';

class EventDetailsProvider extends ChangeNotifier {
  final EventModel event;
  final UserModel user;
  final DBModel db;

  EventDetailsProvider({
    required this.event,
    required this.user,
    required this.db,
  });

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
}
