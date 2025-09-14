import 'package:flutter/material.dart';

class EvaluationDropdown extends StatelessWidget {
  final String label;
  final String field;
  final String studentId;
  final String value;
  final List<String> options;
  final Map<String, String> optionLabels;
  final Function(String, String, String) onChanged;

  const EvaluationDropdown({
    super.key,
    required this.label,
    required this.field,
    required this.studentId,
    required this.value,
    required this.options,
    required this.optionLabels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(studentId, field, newValue);
          }
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options
            .map(
              (opt) => DropdownMenuItem(
            value: opt,
            child: Text(
              optionLabels[opt] ?? opt,
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}