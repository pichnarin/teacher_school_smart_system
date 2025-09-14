
import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/student_avatar.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/student_info.dart';

class StudentCard extends StatelessWidget {
  final dynamic student;

  const StudentCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentAvatar(
                firstName: student.firstName,
                lastName: student.lastName,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StudentInfo(student: student),
              ),
            ],
          ),
        ),
      ),
    );
  }
}