
import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/student_card.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/student_count_header.dart';

import '../../../data/model/enrollment_with_student.dart';

class StudentList extends StatelessWidget {
  final List<EnrollmentWithStudent> students;

  const StudentList({
    super.key,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StudentCountHeader(count: students.length),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return StudentCard(student: students[index].student);
          },
        ),
      ],
    );
  }
}