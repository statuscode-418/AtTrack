import 'package:attrack/models/form_field_model.dart';
import 'package:flutter/material.dart';

class FormFieldCard extends StatelessWidget {
  final FormFieldModel formField;

  const FormFieldCard({
    super.key,
    required this.formField,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              formField.label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formField.type == FieldType.number ? 'Number' : 'Text',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formField.required ? 'Required' : 'Optional',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
