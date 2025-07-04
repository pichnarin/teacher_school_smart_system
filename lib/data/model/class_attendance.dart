
import 'attendance_record.dart';

class ClassAttendance{
  final String classId;
  final DateTime date;
  final List<AttendanceRecord> attendanceRecords;

  const ClassAttendance({
    required this.classId,
    required this.date,
    required this.attendanceRecords,
  });

  @override
  String toString() => 'ClassAttendance(classId: $classId,date: $date ,attendanceRecords: $attendanceRecords)';

}