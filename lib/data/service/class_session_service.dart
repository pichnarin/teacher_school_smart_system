import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/data/model/dto/class_session_dto.dart';
import 'package:pat_asl_portal/data/repository/class_session_repository.dart';

import '../model/class_session.dart';

class ClassSessionService {
  final ClassSessionRepository _repository;

  ClassSessionService({required ClassSessionRepository repository})
    : _repository = repository;


  /// Retrieves all assigned classes
  ///
  /// Returns a list of Class domain objects ready to be used by the UI
  /// Throws exceptions from the repository layer
  Future<List<ClassSession>> getAllAssignedClassSessions() async {
    final sessionDTOs = await _repository.fetchAllClassSessions();
    return sessionDTOs.map((dto) => dto.toClassSession()).toList();
  }

  /// Retrieves classes by date example: 2023-10-01
  /// use this method to get classes for today, tomorrow, or any specific date
  Future<List<ClassSession>> getClasseSessionByDate(String date) async {
    final sessionDTOs = await _repository.fetchClassSessionByDate(date);
    return sessionDTOs.map((dto) => dto.toClassSession()).toList();
  }

  Future<List<ClassSession>> getClassSessionByRoom(String room) async {
    final sessionDTOs = await _repository.fetchClassSessionByRoom(room);
    return sessionDTOs.map((dto) => dto.toClassSession()).toList();
  }

  Future<List<ClassSession>> getClassSessionByGrade(String grade) async {
    final sessionDTOs = await _repository.fetchClassSessionByGrade(grade);
    return sessionDTOs.map((dto) => dto.toClassSession()).toList();
  }

  Future<List<ClassSession>> getClassSessionByID(String classId) async {
    final sessionDTOs = await _repository.fetchClassSessionById(classId);
    return sessionDTOs.map((dto) => dto.toClassSession()).toList();
  }

}
