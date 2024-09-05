import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'create_event_view_model.dart';
import '../../components/textbox.dart';

class CreateEventScreen extends StatelessWidget {
  final DBModel db;
  final String uid;

  const CreateEventScreen({
    super.key,
    required this.db,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateEventViewModel(db: db, uid: uid),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Events'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Form(
              child: Consumer<CreateEventViewModel>(
                builder: (context, viewModel, child) {
                  return Column(
                    children: [
                      Column(
                        children: [
                          viewModel.selectedImage != null
                              ? Container(
                                  width: double.infinity,
                                  height: 250,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          FileImage(viewModel.selectedImage!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: viewModel.pickImage,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image,
                                              size: 50, color: Colors.grey),
                                          Text('Tap to upload image',
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      TextBox(
                        controller: viewModel.titleController,
                        label: 'Title',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        enableSuggestions: true,
                        autocorrect: true,
                      ),
                      const SizedBox(height: 15),
                      TextBox(
                        controller: viewModel.descriptionController,
                        label: 'Description',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        enableSuggestions: true,
                        autocorrect: true,
                      ),
                      const SizedBox(height: 15),
                      TextBox(
                        controller: viewModel.websiteController,
                        label: 'Website',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        enableSuggestions: true,
                        autocorrect: true,
                      ),
                      const SizedBox(height: 15),
                      TextBox(
                        controller: viewModel.addressController,
                        label: 'Address',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        enableSuggestions: true,
                        autocorrect: true,
                      ),
                      const SizedBox(height: 15),
                      TextBox(
                        controller: viewModel.cityController,
                        label: 'City',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        enableSuggestions: true,
                        autocorrect: true,
                      ),
                      const SizedBox(height: 15),
                      TextBox(
                        controller: viewModel.dateTimeController,
                        label: 'Event Date & Time',
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.datetime,
                        enableSuggestions: false,
                        autocorrect: false,
                        readOnly: true,
                        onTap: () => viewModel.pickDateTime(context),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => viewModel.createEvent(context),
                        child: const Text(
                          'Create',
                          style: TextStyle(color: Colors.cyan, fontSize: 15),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
