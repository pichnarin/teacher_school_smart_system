import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/student_card_evaluation.dart';

import '../../../data/model/enrollment_with_student.dart';

class StudentList extends StatelessWidget {
  final List<dynamic> students;
  final Map<String, Map<String, dynamic>> studentInputs;
  final List<String> evaluationOptionKeys;
  final Map<String, String> evaluationOptions;
  final Function(String, String, String) onInputChanged;
  final Function(String, double) onSliderChanged;

  const StudentList({
    super.key,
    required this.students,
    required this.studentInputs,
    required this.evaluationOptionKeys,
    required this.evaluationOptions,
    required this.onInputChanged,
    required this.onSliderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        dynamic entry = students[index];
        final student = entry is EnrollmentWithStudent ? entry.student : entry;

        return StudentEvaluationCard(
          student: student,
          studentInput: studentInputs[student.id]!,
          evaluationOptionKeys: evaluationOptionKeys,
          evaluationOptions: evaluationOptions,
          onInputChanged: onInputChanged,
          onSliderChanged: onSliderChanged,
        );
      },
    );
  }
}