class Enrollment {
  final String enrollmentId;
  final String classId;
  final String studentId;

  const Enrollment({
    required this.enrollmentId,
    required this.classId,
    required this.studentId
  });

  @override
  String toString() => 'Enrollment(id: $enrollmentId, classId: $classId, studentId: $studentId)';
}