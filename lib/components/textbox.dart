import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool enableSuggestions;
  final bool autocorrect;
  final String? Function(String?)? validator;

  const TextBox({
    super.key,
    required this.label,
    required this.controller,
    required this.textInputAction,
    required this.keyboardType,
    required this.enableSuggestions,
    required this.autocorrect,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        label: Text(label, style: const TextStyle(color: Colors.white)),
        filled: true,
        fillColor: Colors.transparent,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.cyan),
        ),
      ),
      validator: validator,
    );
  }
}
