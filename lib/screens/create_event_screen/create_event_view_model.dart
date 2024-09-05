import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:attrack/models/event_model.dart';
import 'package:attrack/services/cloud_storage/image_service.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/utils/default_form/default_form.dart';

class CreateEventViewModel extends ChangeNotifier {
  final DBModel db;
  final String uid;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();

  DateTime? selectedDateTime;
  File? selectedImage;

  CreateEventViewModel({required this.db, required this.uid});

  Future<void> pickDateTime(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        selectedDateTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        dateTimeController.text =
            "${"${selectedDateTime!.toLocal()}".split(' ')[0]} ${time.format(context)}";
        notifyListeners();
      }
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);
      notifyListeners();
    }
  }

  Future<void> createEvent(BuildContext context) async {
    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date and time for the event'),
        ),
      );
      return;
    }

    var eid = const Uuid().v4();
    var imageUrl = selectedImage != null
        ? await ImageService()
            .uploadImageForEvent(image: selectedImage!, uid: eid)
        : null;

    var event = EventModel.newEvent(
      uid: uid,
      mid: eid,
      title: titleController.text,
      date: selectedDateTime!,
      city: cityController.text,
      address: addressController.text,
      latitude: 0.0,
      longitude: 0.0,
      deadline: selectedDateTime!,
      description: descriptionController.text,
      website: websiteController.text,
      photoUrl: imageUrl,
    );

    var form = getDefaultForm(eid, uid);
    await db.createEvent(event);
    await db.createForm(form);

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    cityController.dispose();
    websiteController.dispose();
    dateTimeController.dispose();
    super.dispose();
  }
}
