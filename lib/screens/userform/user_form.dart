import 'package:attrack/models/form_field_answer.dart';
import 'package:attrack/models/form_model.dart';
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

  @override
  void initState() {
    super.initState();
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    form = args['form'] as FormModel;
    answers =
        form.fields.map((field) => FieldAnswer.fromField(field, '')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
      ),
      body: ListView.builder(
        itemCount: form.fields.length,
        itemBuilder: (context, index) {
          var answer = answers[index];
          return TextAnswerField(
              fieldAnswer: answer,
              onChanged: (value) {
                setState(() {
                  answers[index] = answer.copyWith(answer: value);
                });
              },
              enabled: true);
        },
      ),
    );
  }
}
