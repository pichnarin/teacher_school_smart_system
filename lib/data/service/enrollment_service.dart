import '../model/checked_attendance_record.dart';
import '../model/dto/class_attendance_dto.dart';
import '../model/enrollment_with_student.dart';
import '../repository/enrollment_repository.dart';

class EnrollmentService {
  final EnrollmentRepository _repository;

  EnrollmentService({required EnrollmentRepository repository})
      : _repository = repository;

  Future<List<EnrollmentWithStudent>> getEnrollmentsByClassId(String classId) async {
    final enrollmentsWithStudents = await _repository.fetchEnrollmentsByClassId(classId);
    return enrollmentsWithStudents;
  }

  //mark attendance for a student in a class service
  Future<bool> markAttendance(ClassAttendanceDTO attendanceDTO) async {
    return await _repository.markAttendance(attendanceDTO);
  }

  // Update attendance records for a class service
  Future<bool> patchStudentAttendance(String attendanceId, String newStatus) async {
    return await _repository.patchAttendance(attendanceId, newStatus);
  }

  // Fetch attendance records for a class on a specific date
  Future<List<CheckedAttendanceRecord>> getAttendanceByClassSession({
    required String classId,
    required String classSessionId,
  }) async {
    return await _repository.getAttendanceByClassSession(classId: classId, classSessionId: classSessionId);
  }

}