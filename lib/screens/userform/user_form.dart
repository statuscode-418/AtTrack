import 'package:attrack/models/form_field_answer.dart';
import 'package:attrack/models/form_model.dart';
import 'package:attrack/models/user_model.dart';
import 'package:attrack/screens/userform/components/text_answer_field.dart';
import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  late FormModel form;
  late List<FieldAnswer> answers;
  late UserModel user;
  List<Widget> fields = [];

  @override
  void initState() {
    super.initState();
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    form = args['form'] as FormModel;
    user = args['user'] as UserModel;
    answers =
        form.fields.map((field) => FieldAnswer.fromField(field, '')).toList();
    // Will use a better approach later
    fields = form.fields.map(
      (field) {
        TextEditingController? controller;
        bool enabled = true;
        if (field.id == 'name') {
          controller = TextEditingController(text: user.name);
          enabled = false;
        } else if (field.id == 'email') {
          controller = TextEditingController(text: user.email);
          enabled = false;
        } else if (field.id == 'phone') {
          controller = TextEditingController(text: user.phoneNumber);
          enabled = false;
        } else if (field.id == 'instagram') {
          controller = TextEditingController(text: user.instagram);
        } else if (field.id == 'github') {
          controller = TextEditingController(text: user.github);
        } else if (field.id == 'linkedin') {
          controller = TextEditingController(text: user.linkedin);
        }
        return TextAnswerField(
          fieldAnswer: answers[field.index],
          controller: controller,
          onChanged: (value) {
            setState(() {
              answers[field.index] =
                  answers[field.index].copyWith(answer: value);
            });
          },
          enabled: enabled,
        );
      },
    ).toList();
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
                onPressed: () {
                  // Save answers
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
