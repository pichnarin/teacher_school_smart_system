
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/student_dob_badge.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/student_id_badge.dart';

class StudentInfo extends StatelessWidget {
  final dynamic student;

  const StudentInfo({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                student.getFullName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            StudentIdBadge(id: student.studentNumber),
          ],
        ),
        const SizedBox(height: 12),
        StudentDobBadge(dob: student.dob),
      ],
    );
  }
}