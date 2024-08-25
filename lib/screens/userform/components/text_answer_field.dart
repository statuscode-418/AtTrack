import 'package:attrack/models/form_field_answer.dart';
import 'package:attrack/models/form_field_model.dart';
import 'package:flutter/material.dart';

class TextAnswerField extends StatelessWidget {
  final FieldAnswer fieldAnswer;
  final TextEditingController? controller;
  final void Function(String) onChanged;
  final bool enabled;

  const TextAnswerField({
    super.key,
    required this.fieldAnswer,
    required this.onChanged,
    required this.enabled,
    this.controller,
  });

  TextInputType get keyboardType {
    switch (fieldAnswer.type) {
      case FieldType.number:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: (value) {
        if (fieldAnswer.required && value!.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: fieldAnswer.label,
      ),
    );
  }
}
