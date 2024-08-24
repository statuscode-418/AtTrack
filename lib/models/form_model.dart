import 'form_field_model.dart';
import 'model_constants.dart';

class FormModel {
  final String eid;
  final String uid;
  final String fid;

  final List<FormFieldModel> fields;

  FormModel({
    required this.eid,
    required this.uid,
    required this.fid,
    required this.fields,
  });

  Map<String, dynamic> toMap() {
    return {
      ModelConsts.eid: eid,
      ModelConsts.uid: uid,
      ModelConsts.fid: fid,
    };
  }

  factory FormModel.fromMap(Map<String, dynamic> map, List<FormFieldModel> fields) {
    return FormModel(
      eid: map[ModelConsts.eid],
      uid: map[ModelConsts.uid],
      fid: map[ModelConsts.fid],
      fields: fields,
    );
  }
}
