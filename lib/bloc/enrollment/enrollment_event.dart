import 'package:equatable/equatable.dart';
import 'package:pat_asl_portal/data/model/dto/class_attendance_dto.dart';

abstract class EnrollmentEvent extends Equatable {
  const EnrollmentEvent();

  @override
  List<Object?> get props => [];
}

class FetchEnrollmentsByClassId extends EnrollmentEvent {
  final String classId;

  const FetchEnrollmentsByClassId(this.classId);

  @override
  List<Object?> get props => [classId];
}

class MarkAttendance extends EnrollmentEvent{
  final ClassAttendanceDTO attendanceDTO;
  const MarkAttendance(this.attendanceDTO);

  @override
  List<Object?> get props => [attendanceDTO];
}

class PatchStudentAttendanceRecord extends EnrollmentEvent {
  final String attendanceId;
  final String status;

  const PatchStudentAttendanceRecord({
    required this.attendanceId,
    required this.status,
  });

  @override
  List<Object?> get props => [attendanceId, status];
}

class FetchAttendanceRecords extends EnrollmentEvent {
  final String classId;
  final String date;

  const FetchAttendanceRecords({required this.classId, required this.date});

  @override
  List<Object?> get props => [classId, date];
}


