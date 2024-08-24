import 'model_constants.dart';

enum FieldType { text, number, option }

class FormFieldModel {
  final String id;
  final String label;
  final FieldType type;
  final int index;
  final bool required;

  const FormFieldModel({
    required this.id,
    required this.label,
    required this.type,
    required this.index,
    required this.required,
  });

  Map<String, dynamic> toMap() {
    return {
      ModelConsts.id: id,
      ModelConsts.label: label,
      ModelConsts.type: type.index,
      ModelConsts.isRequired: required,
      ModelConsts.index: index,
    };
  }

  factory FormFieldModel.fromMap(Map<String, dynamic> map) {
    var type = FieldType.values[map[ModelConsts.type]];
    switch (type) {
      case FieldType.text:
        return FormTextField.fromMap(map);
      case FieldType.number:
        return NumberField.fromMap(map);
      case FieldType.option:
        return OptionField.fromMap(map);
    }
  }
}

class FormTextField extends FormFieldModel {
  const FormTextField({
    required super.id,
    required super.label,
    required super.required,
    required super.index,
  }) : super(
          type: FieldType.text,
        );

  factory FormTextField.fromMap(Map<String, dynamic> map) {
    return FormTextField(
      id: map[ModelConsts.id],
      label: map[ModelConsts.label],
      required: map[ModelConsts.isRequired],
      index: map[ModelConsts.index],
    );
  }
}

class NumberField extends FormFieldModel {
  const NumberField({
    required super.id,
    required super.label,
    required super.required,
    required super.index,
  }) : super(
          type: FieldType.number,
        );

  factory NumberField.fromMap(Map<String, dynamic> map) {
    return NumberField(
      id: map[ModelConsts.id],
      label: map[ModelConsts.label],
      required: map[ModelConsts.isRequired],
      index: map[ModelConsts.index],
    );
  }
}

class OptionField extends FormFieldModel {
  final List<String> options;

  const OptionField({
    required super.id,
    required this.options,
    required super.label,
    required super.required,
    required super.index,
  }) : super(
          type: FieldType.option,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      ModelConsts.options: options,
    };
  }

  factory OptionField.fromMap(Map<String, dynamic> map) {
    return OptionField(
      id: map[ModelConsts.id],
      label: map[ModelConsts.label],
      required: map[ModelConsts.isRequired],
      options: List<String>.from(map[ModelConsts.options]),
      index: map[ModelConsts.index],
    );
  }
}
