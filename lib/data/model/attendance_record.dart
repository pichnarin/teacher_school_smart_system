class AttendanceRecord{
  final String? id; //attendance exam_record ID, optional for new records
  final String studentId;
  final String classSessionId;
  final String status;

  const AttendanceRecord({
    this.id,
    required this.studentId,
    required this.status,
    required this.classSessionId,
  });

  @override
  String toString() => 'AttendanceRecord(id:$id ,studentId: $studentId, status: $status, classSessionId: $classSessionId)';
}
