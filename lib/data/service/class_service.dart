import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/data/model/dto/class_session_dto.dart';
import 'package:pat_asl_portal/data/repository/class_session_repository.dart';

import '../model/class_session.dart';
import '../model/student_report.dart';
import '../repository/class_repository.dart';

class ClassService {
  final ClassRepository _repository;

  ClassService({required ClassRepository repository})
      : _repository = repository;


  /// Retrieves all assigned classes
  ///
  /// Returns a list of Class domain objects ready to be used by the UI
  /// Throws exceptions from the repository layer
  Future<List<Class>> fetchAllClasses() async {
    final sessionDTOs = await _repository.fetchAllClasses();
    return sessionDTOs.map((dto) => dto.toClass()).toList();
  }

  /// Retrieves classes by date example: 2023-10-01
  /// use this method to get classes for today, tomorrow, or any specific date
  Future<List<Class>> fetchClassByDate(String date) async {
    final sessionDTOs = await _repository.fetchClassByDate(date);
    debugPrint('sessionDTOs: $sessionDTOs');
    return sessionDTOs.map((dto) => dto.toClass()).toList();
  }

  Future<List<Class>> fetchClassByRoom(String room) async {
    final sessionDTOs = await _repository.fetchClassByRoom(room);
    return sessionDTOs.map((dto) => dto.toClass()).toList();
  }

  Future<List<Class>> fetchClassByGrade(String grade) async {
    final sessionDTOs = await _repository.fetchClassByGrade(grade);
    return sessionDTOs.map((dto) => dto.toClass()).toList();
  }

  Future<List<Class>> fetchClassById(String classId) async {
    final sessionDTOs = await _repository.fetchClassById(classId);
    return sessionDTOs.map((dto) => dto.toClass()).toList();
  }

  Future<List<StudentReport>> fetchStudentReport(String classId, String month, String year) async{
    final sessionDTOs = await _repository.fetchStudentReport(classId, month, year);
    return sessionDTOs.map((dto) => dto.toStudentReport()).toList();
  }

}
