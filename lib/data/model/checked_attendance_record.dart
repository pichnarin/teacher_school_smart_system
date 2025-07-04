
class CheckedAttendanceRecord {
  final String id;
  final String studentId;
  final String studentNo;
  final String studentName;
  final String status;
  final DateTime date;

  CheckedAttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentNo,
    required this.studentName,
    required this.status,
    required this.date,
  });

  factory CheckedAttendanceRecord.fromJson(Map<String, dynamic> json) {
    return CheckedAttendanceRecord(
      id: json['id'],
      studentId: json['student_id'],
      studentNo: json['student_no'],
      studentName: json['student_name'],
      status: json['status'],
      date: DateTime.parse(json['date']),
    );
  }

  @override
  String toString() {
    return 'CheckedAttendanceRecord(id: $id, studentId: $studentId, studentNo: $studentNo, studentName: $studentName, status: $status, date: $date)';
  }
}
