import '../attendance_record.dart';

class AttendanceRecordDTO{
  final String studentId;
  final String classSessionId;
  final String status;

  const AttendanceRecordDTO({
    required this.studentId,
    required this.status,
    required this.classSessionId,
  });

  factory AttendanceRecordDTO.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordDTO(
      studentId: json['student_id'] ?? '',
      status: json['status'] ?? '',
      classSessionId: json['class_session_id'] ?? '',
    );
  }

  AttendanceRecord toAttendanceRecord() => AttendanceRecord(
    studentId: studentId,
    status: status,
    classSessionId: classSessionId
  );

  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'status': status,
    'class_session_id': classSessionId,
  };


  static AttendanceRecordDTO fromAttendanceRecord(AttendanceRecord attendanceRecord) {
    return AttendanceRecordDTO(
      studentId: attendanceRecord.studentId,
      status: attendanceRecord.status,
      classSessionId: attendanceRecord.classSessionId,
    );
  }
}