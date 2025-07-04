import '../attendance_record.dart';
import '../class_attendance.dart';
import 'attendance_record_dto.dart';

class ClassAttendanceDTO {
  final String classId;
  final DateTime date;
  final List<AttendanceRecord> attendanceRecords;

  const ClassAttendanceDTO({
    required this.classId,
    required this.date,
    required this.attendanceRecords,
  });

  factory ClassAttendanceDTO.fromJson(Map<String, dynamic> json) {
    return ClassAttendanceDTO(
      classId: json['class_id'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
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
      'date': date.toIso8601String().split('T')[0], // Format: YYYY-MM-DD
      'attendances': attendanceRecords
          .map((record) => AttendanceRecordDTO.fromAttendanceRecord(record).toJson())
          .toList(),
    };
  }

  ClassAttendance toClassAttendance() {
    return ClassAttendance(
      classId: classId,
      date: date,
      attendanceRecords: attendanceRecords,
    );
  }

  static ClassAttendanceDTO fromClassAttendance(ClassAttendance classAttendance) {
    return ClassAttendanceDTO(
      classId: classAttendance.classId,
      date: classAttendance.date,
      attendanceRecords: classAttendance.attendanceRecords,
    );
  }
}