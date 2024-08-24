import 'dart:io';

import 'package:attrack/models/user_model.dart';
import 'package:attrack/services/cloud_storage/image_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/textbox.dart';

class UserDetailsView extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onSubmit;
  const UserDetailsView({
    super.key,
    required this.user,
    required this.onSubmit,
  });

  @override
  State<UserDetailsView> createState() => _UserDetailsViewState();
}

class _UserDetailsViewState extends State<UserDetailsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserModel get user => widget.user;
  late final TextEditingController _nameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _githubController;
  late final TextEditingController _linkedinController;
  late final TextEditingController _instagramController;
  late final ImagePicker _picker;
  File? _imageFile;
  final ImageService _imageService =
      ImageService(firebaseStorage: FirebaseStorage.instance);

  @override
  void initState() {
    _nameController = TextEditingController(text: user.name);
    _phoneNumberController = TextEditingController(text: user.phoneNumber);
    _linkedinController = TextEditingController(text: user.linkedin);
    _githubController = TextEditingController(text: user.github);
    _instagramController = TextEditingController(text: user.instagram);
    _picker = ImagePicker();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _githubController.dispose();
    _linkedinController.dispose();
    _phoneNumberController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                      child: _imageFile == null
                          ? const Icon(Icons.camera_alt, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Please enter your details...',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  TextBox(
                    label: 'Name',
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    enableSuggestions: true,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextBox(
                    label: 'Phone Number',
                    controller: _phoneNumberController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    enableSuggestions: true,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone Number can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextBox(
                    label: 'GitHub',
                    controller: _githubController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.url,
                    enableSuggestions: true,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "GitHub can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextBox(
                    label: 'LinkedIn',
                    controller: _linkedinController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.url,
                    enableSuggestions: true,
                    autocorrect: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "LinkedIn can't be empty";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextBox(
                    label: 'Instagram',
                    controller: _instagramController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.url,
                    enableSuggestions: true,
                    autocorrect: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }

                      String? photoUrl;
                      if (_imageFile != null) {
                        photoUrl = await _imageService.uploadImageForProfile(
                          image: _imageFile!,
                          uid: user.uid,
                        );
                      }
                      var updatedCred = user.copyWith(
                        name: _nameController.text,
                        github: _githubController.text,
                        linkedin: _linkedinController.text,
                        instagram: _instagramController.text,
                        phoneNumber: _phoneNumberController.text,
                        photoUrl: photoUrl,
                      );
                      widget.onSubmit(updatedCred);
                    },
                    child: const Text('Submit'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
