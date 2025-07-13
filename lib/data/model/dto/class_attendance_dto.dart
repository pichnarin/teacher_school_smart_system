import '../attendance_record.dart';
import '../class_attendance.dart';
import 'attendance_record_dto.dart';

class ClassAttendanceDTO {
  final String classId;
  final String classSessionId;
  final List<AttendanceRecord> attendanceRecords;

  const ClassAttendanceDTO({
    required this.classId,
    required this.classSessionId,
    required this.attendanceRecords,
  });

  factory ClassAttendanceDTO.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceDTO(
      classId: json['class_id'] ?? '',
      classSessionId: json['class_session_id'] ?? '',
      // Fixed typo "attendanes" to "attendances"
      attendanceRecords: (json['attendances'] as List)
          .map((attendance) => AttendanceRecordDTO.fromJson(attendance).toAttendanceRecord())
          .toList(),
    );
  }

  // Added toJson method to convert back to JSON format
  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'class_session_id': classSessionId,
      'attendances': attendanceRecords
          .map((record) => AttendanceRecordDTO.fromAttendanceRecord(record).toJson())
          .toList(),
    };
  }

  // ClassAttendance toClassAttendance() {
  //   return ClassAttendance(
  //     classId: classId,
  //
  //     attendanceRecords: attendanceRecords,
  //   );
  // }
  //
  // static ClassAttendanceDTO fromClassAttendance(ClassAttendance classAttendance) {
  //   return ClassAttendanceDTO(
  //     classId: classAttendance.classId,
  //
  //     attendanceRecords: classAttendance.attendanceRecords,
  //   );
  // }
}