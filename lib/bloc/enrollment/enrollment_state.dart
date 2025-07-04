import 'package:equatable/equatable.dart';
import '../../data/model/enrollment_with_student.dart';

enum EnrollmentStatus {
  initial,
  loading,
  loaded,
  error,
  submittingAttendance,
  attendanceSubmitted,
  patchingAttendance,
  patchedAttendance,
  attendanceError,
  patchingError,
}

class EnrollmentState extends Equatable {
  final EnrollmentStatus status;
  final String? errorMessage;
  final List<EnrollmentWithStudent>? enrollments;
  final String? classId;
  final Map<String, String>? attendanceRecords;
  final Map<String, String>? attendanceRecordIds;
  final bool? attendanceAlreadyExists;

  const EnrollmentState({
    this.status = EnrollmentStatus.initial,
    this.errorMessage,
    this.enrollments,
    this.classId,
    this.attendanceRecords,
    this.attendanceRecordIds,
    this.attendanceAlreadyExists,
  });

  EnrollmentState copyWith({
    EnrollmentStatus? status,
    String? errorMessage,
    List<EnrollmentWithStudent>? enrollments,
    String? classId,
    Map<String, String>? attendanceRecords,
    Map<String, String>? attendanceRecordIds,
    bool? attendanceAlreadyExists,
  }) {
    return EnrollmentState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      enrollments: enrollments ?? this.enrollments,
      classId: classId ?? this.classId,
      attendanceRecords: attendanceRecords ?? this.attendanceRecords,
      attendanceRecordIds: attendanceRecordIds ?? this.attendanceRecordIds,
      attendanceAlreadyExists: attendanceAlreadyExists ?? this.attendanceAlreadyExists,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, enrollments, classId, attendanceRecords, attendanceRecordIds, attendanceAlreadyExists];
}