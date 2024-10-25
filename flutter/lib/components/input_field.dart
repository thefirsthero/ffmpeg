import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const InputField({
    super.key,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    );
  }
}
