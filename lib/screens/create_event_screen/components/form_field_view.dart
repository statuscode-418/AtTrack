import 'package:attrack/models/form_field_model.dart';
import 'package:flutter/material.dart';

import 'form_field_card.dart';

class FormFieldView extends StatelessWidget {
  final List<FormFieldModel> formFields;
  final void Function(FormFieldModel)? onFieldTap;
  final VoidCallback? onFieldAdd;

  const FormFieldView({
    super.key,
    required this.formFields,
    this.onFieldTap,
    this.onFieldAdd,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (var field in formFields)
            FormFieldCard(
              formField: field,
            ),
          if (onFieldAdd != null)
            TextButton(
              onPressed: onFieldAdd,
              child: const Text('Add Field'),
            ),
        ],
      ),
    );
  }
}
