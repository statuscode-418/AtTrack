import 'dart:io';

import 'package:attrack/models/event_model.dart';
import 'package:attrack/services/cloud_storage/image_service.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:attrack/utils/default_form/default_form.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../components/textbox.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _websiteController;
  late final TextEditingController _dateTimeController;
  late final DBModel _db;
  late final String _uid;
  DateTime? _selectedDateTime;
  File? _selectedImage;

  @override
  void initState() {
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _websiteController = TextEditingController();
    _dateTimeController = TextEditingController();

    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _db = args['db'] as DBModel;
    _uid = args['uid'] as String;

    super.initState();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _titleController.dispose();
    _cityController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (!mounted) return;
    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);
          _dateTimeController.text =
              "${"${_selectedDateTime!.toLocal()}".split(' ')[0]} ${time.format(context)}";
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date and time for the event'),
        ),
      );
    }

    var eid = const Uuid().v4();
    var imageUrl = _selectedImage != null
        ? await ImageService()
            .uploadImageForEvent(image: _selectedImage!, uid: eid)
        : null;
    var event = EventModel.newEvent(
      uid: _uid,
      mid: eid,
      title: _titleController.text,
      date: _selectedDateTime!,
      city: _cityController.text,
      address: _addressController.text,
      latitude: 0.0,
      longitude: 0.0,
      deadline: _selectedDateTime!,
      description: _descriptionController.text,
      website: _websiteController.text,
      photoUrl: imageUrl,
    );
    var form = getDefaultForm(eid, _uid);
    await _db.createEvent(event);
    await _db.createForm(form);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Events'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    _selectedImage != null
                        ? Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 150,
                              width: 150,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image,
                                        size: 50, color: Colors.grey),
                                    Text('Tap to upload image',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
                TextBox(
                  controller: _titleController,
                  label: 'Title',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  enableSuggestions: true,
                  autocorrect: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextBox(
                  controller: _descriptionController,
                  label: 'Description',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  enableSuggestions: true,
                  autocorrect: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextBox(
                  controller: _websiteController,
                  label: 'Website',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  enableSuggestions: true,
                  autocorrect: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextBox(
                  controller: _addressController,
                  label: 'Address',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  enableSuggestions: true,
                  autocorrect: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextBox(
                  controller: _cityController,
                  label: 'City',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  enableSuggestions: true,
                  autocorrect: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextBox(
                  controller: _dateTimeController,
                  label: 'Event Date & Time',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.datetime,
                  enableSuggestions: false,
                  autocorrect: false,
                  readOnly: true,
                  onTap: _pickDateTime,
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: _createEvent,
                  child: const Text(
                    'Create',
                    style: TextStyle(color: Colors.cyan, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
