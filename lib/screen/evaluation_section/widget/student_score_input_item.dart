import 'package:flutter/material.dart';

class StudentScoreInputItem extends StatelessWidget {
  final dynamic student;
  final Function(String) onScoreChanged;
  final String? Function(String?) validateScore;

  const StudentScoreInputItem({
    super.key,
    required this.student,
    required this.onScoreChanged,
    required this.validateScore,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(Icons.person, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(
          student.getFullName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(student.studentNumber),
        trailing: SizedBox(
          width: 100,
          child: TextFormField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Score',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
            ),
            onChanged: onScoreChanged,
            validator: validateScore,
          ),
        ),
      ),
    );
  }
}