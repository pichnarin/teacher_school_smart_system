import 'package:flutter/material.dart';

import 'evaluation_dropdown.dart';

class StudentEvaluationCard extends StatelessWidget {
  final dynamic student;
  final Map<String, dynamic> studentInput;
  final List<String> evaluationOptionKeys;
  final Map<String, String> evaluationOptions;
  final Function(String, String, String) onInputChanged;
  final Function(String, double) onSliderChanged;

  const StudentEvaluationCard({
    super.key,
    required this.student,
    required this.studentInput,
    required this.evaluationOptionKeys,
    required this.evaluationOptions,
    required this.onInputChanged,
    required this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${student.studentNumber} - ${student.firstName} ${student.lastName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                EvaluationDropdown(
                  label: "កិច្ចការផ្ទះ",
                  field: "homework",
                  studentId: student.id,
                  value: studentInput["homework"],
                  options: evaluationOptionKeys,
                  optionLabels: evaluationOptions,
                  onChanged: onInputChanged,
                ),
                const SizedBox(width: 10),
                EvaluationDropdown(
                  label: "សម្លាក់បំពាក់",
                  field: "clothing",
                  studentId: student.id,
                  value: studentInput["clothing"],
                  options: evaluationOptionKeys,
                  optionLabels: evaluationOptions,
                  onChanged: onInputChanged,
                ),
                const SizedBox(width: 10),
                EvaluationDropdown(
                  label: "អាកប្បកិរិយា",
                  field: "attitude",
                  studentId: student.id,
                  value: studentInput["attitude"],
                  options: evaluationOptionKeys,
                  optionLabels: evaluationOptions,
                  onChanged: onInputChanged,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "សកម្មភាពក្នុងថ្នាក់: ${studentInput['class_activity']}",
            ),
            Slider(
              value: studentInput['class_activity'].toDouble(),
              min: 0,
              max: 10,
              divisions: 10,
              label: studentInput['class_activity'].toString(),
              onChanged: (value) {
                onSliderChanged(student.id, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}