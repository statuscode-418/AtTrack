import 'package:attrack/models/form_field_answer.dart';
import 'package:attrack/models/form_model.dart';
import 'package:attrack/models/form_submission.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/userform/components/text_answer_field.dart';
import 'package:attrack/services/firestore_storage/db_model.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserForm extends StatefulWidget {
  final FormModel form;
  final UserModel user;
  final DBModel db;

  const UserForm({
    super.key,
    required this.form,
    required this.user,
    required this.db,
  });

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  FormModel get form => widget.form;
  late List<FieldAnswer> answers;

  UserModel get user => widget.user;
  List<Widget> fields = [];

  @override
  void initState() {
    super.initState();
    answers =
        form.fields.map((field) => FieldAnswer.fromField(field, '')).toList();
    fields = [];
    for (var i = 0; i < form.fields.length; i++) {
      final field = form.fields[i];
      TextEditingController? controller;
      bool enabled = true;
      if (field.id == 'name') {
        answers[i] = answers[i].copyWith(answer: user.name);
        controller = TextEditingController(text: user.name);
        enabled = false;
      } else if (field.id == 'email') {
        answers[i] = answers[i].copyWith(answer: user.email);
        controller = TextEditingController(text: user.email);
        enabled = false;
      } else if (field.id == 'phone') {
        answers[i] = answers[i].copyWith(answer: user.phoneNumber);
        controller = TextEditingController(text: user.phoneNumber);
        enabled = false;
      } else if (field.id == 'instagram') {
        answers[i] = answers[i].copyWith(answer: user.instagram);
        controller = TextEditingController(text: user.instagram);
      } else if (field.id == 'github') {
        answers[i] = answers[i].copyWith(answer: user.github);
        controller = TextEditingController(text: user.github);
      } else if (field.id == 'linkedin') {
        answers[i] = answers[i].copyWith(answer: user.linkedin);
        controller = TextEditingController(text: user.linkedin);
      }
      fields.add(
        TextAnswerField(
          fieldAnswer: answers[i],
          controller: controller,
          onChanged: (value) {
            setState(() {
              answers[i] = answers[i].copyWith(answer: value);
            });
          },
          enabled: enabled,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              ...fields,
              ElevatedButton(
                onPressed: () async {
                  await widget.db.createSubmission(
                    FormSubmission(
                      sid: const Uuid().v4(),
                      fid: form.fid,
                      userCode: user.uniqueCode,
                      eid: form.eid,
                      answers: answers,
                      submittedAt: DateTime.now(),
                    ),
                  );
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
