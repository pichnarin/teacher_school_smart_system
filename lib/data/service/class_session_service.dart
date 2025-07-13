import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/data/model/dto/class_session_dto.dart';
import 'package:pat_asl_portal/data/repository/class_repository.dart';

import '../model/class_session.dart';

class ClassService {
  final ClassRepository _repository;

  ClassService({required ClassRepository repository})
    : _repository = repository;

  /// Retrieves all classes
  /// /// Returns a list of Class domain objects ready to be used by the UI
  /// /// Throws exceptions from the repository layer
  Future<List<Class>> getAllClasses() async {
    final classDTOs = await _repository.fetchAllClasses();

    return classDTOs.map((dto) => dto.toClass()).toList();
  }


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
  Future<List<ClassSession>> getClassesByDate(String date) async {
    final sessionDTOs = await _repository.fetchClassByDate(date);

    return sessionDTOs.map((dto) => dto.toClassSession()).toList();
  }

  Future<List<ClassSession>> getClassesByRoom(String room) async {
    final sessionDTOs = await _repository.fetchClassByRoom(room);

    return sessionDTOs.map((dto) => dto.toClassSession()).toList();
  }

  Future<List<ClassSession>> getClassesByGrade(String grade) async {
    final sessionDTOs = await _repository.fetchClassByGrade(grade);

    return sessionDTOs.map((dto) => dto.toClassSession()).toList();
  }

  Future<List<ClassSession>> getClassByID(String classId) async {
    final sessionDTOs = await _repository.fetchClassById(classId);
    return sessionDTOs.map((dto) => dto.toClassSession()).toList();
  }



}
