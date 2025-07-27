import 'package:pat_asl_portal/data/model/dto/class_session_dto.dart';
import 'package:pat_asl_portal/data/repository/session_repository.dart';
import 'package:pat_asl_portal/util/exception/api_exception.dart';

class SessionService {
  final SessionRepository _sessionRepository;

  SessionService({required SessionRepository sessionRepository})
      : _sessionRepository = sessionRepository;

  /// Gets the active session for a specific class
  ///
  /// Returns a SessionDTO object
  /// Throws [ApiException] if the request fails
  Future<ClassSessionDTO> getActiveSession(String classId, String sessionDate, String startTime, String endTime) async {
    try {
      return await _sessionRepository.fetchActiveSession(classId, sessionDate, startTime, endTime);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Service error: ${e.toString()}', 500);
    }
  }

  /// Patches the exam type for a specific class session
 /// [classSessionId] is the ID of the class session to update
 /// [sessionTypeId] is the ID of the session type to set
  Future<void> patchExamType(String classSessionId, String sessionTypeId) async {
    try {
      await _sessionRepository.patchExamType(classSessionId, sessionTypeId);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Service error: ${e.toString()}', 500);
    }
  }
}