
import '../enrollment.dart';

class EnrollmentDTO {
  final String id;
  final String classId;
  final String studentId;

  const EnrollmentDTO({
    required this.id,
    required this.classId,
    required this.studentId
  });

  factory EnrollmentDTO.fromJson(Map<String, dynamic> json) {
    return EnrollmentDTO(
      id: json['id'] ?? '',
      classId: json['class_id'] ?? '',
      studentId: json['student_id'] ?? ''
    );
  }

  Enrollment toEnrollment() => Enrollment(
    enrollmentId: id,
    classId: classId,
    studentId: studentId,
  );
}