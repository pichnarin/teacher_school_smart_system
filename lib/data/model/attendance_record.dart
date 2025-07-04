class AttendanceRecord{
  final String? id; //attendance record ID, optional for new records
  final String studentId;
  final String status;

  const AttendanceRecord({
    this.id,
    required this.studentId,
    required this.status,
  });

  @override
  String toString() => 'AttendanceRecord(id:$id ,studentId: $studentId, status: $status)';
}
