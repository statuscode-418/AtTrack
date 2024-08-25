import 'package:attrack/models/form_field_model.dart';
import 'package:attrack/models/form_model.dart';
import 'package:uuid/uuid.dart';

FormModel getDefaultForm(
  String eid,
  String uid,
) {
  return FormModel(
    eid: eid,
    uid: uid,
    fid: const Uuid().v4(),
    fields: [
      const FormFieldModel(
          id: 'name',
          label: 'Name',
          type: FieldType.text,
          index: 1,
          required: true),
      const FormFieldModel(
          id: 'email',
          label: 'Email',
          type: FieldType.text,
          index: 2,
          required: true),
      const FormFieldModel(
          id: 'phone',
          label: 'Phone No',
          type: FieldType.text,
          index: 3,
          required: true),
      const FormFieldModel(
          id: 'instagram',
          label: 'Name',
          type: FieldType.text,
          index: 4,
          required: false),
      const FormFieldModel(
          id: 'github',
          label: 'Name',
          type: FieldType.text,
          index: 5,
          required: false),
      const FormFieldModel(
          id: 'linkedin',
          label: 'Name',
          type: FieldType.text,
          index: 6,
          required: false),
    ],
  );
}
