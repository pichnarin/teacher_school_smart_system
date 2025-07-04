import 'package:pat_asl_portal/data/model/student.dart';
import 'enrollment.dart';

class EnrollmentWithStudent {
  final Enrollment enrollment;
  final Student student;

  const EnrollmentWithStudent({
    required this.enrollment,
    required this.student,
  });

  @override
  String toString() => 'EnrollmentWithStudent(enrollment: $enrollment, student: $student)';
}


