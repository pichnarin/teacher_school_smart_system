import '../attendance_record.dart';

class AttendanceRecordDTO{
  final String studentId;
  final String status;

  const AttendanceRecordDTO({
    required this.studentId,
    required this.status,
  });

  factory AttendanceRecordDTO.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordDTO(
      studentId: json['student_id'] ?? '',
      status: json['status'] ?? '',
    );
  }

  AttendanceRecord toAttendanceRecord() => AttendanceRecord(
    studentId: studentId,
    status: status,
  );

  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'status': status,
  };


  static AttendanceRecordDTO fromAttendanceRecord(AttendanceRecord attendanceRecord) {
    return AttendanceRecordDTO(
      studentId: attendanceRecord.studentId,
      status: attendanceRecord.status,
    );
  }
}