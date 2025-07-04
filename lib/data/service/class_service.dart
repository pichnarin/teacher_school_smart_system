import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/data/repository/class_repository.dart';

class ClassService {
  final ClassRepository _repository;

  ClassService({required ClassRepository repository})
    : _repository = repository;

  /// Retrieves all assigned classes
  ///
  /// Returns a list of Class domain objects ready to be used by the UI
  /// Throws exceptions from the repository layer
  Future<List<Class>> getAllAssignedClasses() async {
    final classDTOs = await _repository.fetchAllAssignedClass();

    return classDTOs.map((dto) => dto.toClass()).toList();
  }

  /// Retrieves classes by date example: 2023-10-01
  /// use this method to get classes for today, tomorrow, or any specific date
  Future<List<Class>> getClassesByDate(String date) async {
    final classDTOs = await _repository.fetchClassByDate(date);

    return classDTOs.map((dto) => dto.toClass()).toList();
  }

  Future<List<Class>> getClassesByRoom(String room) async {
    final classDTOs = await _repository.fetchClassByRoom(room);

    return classDTOs.map((dto) => dto.toClass()).toList();
  }

  Future<List<Class>> getClassesByGrade(String grade) async {
    final classDTOs = await _repository.fetchClassByGrade(grade);

    return classDTOs.map((dto) => dto.toClass()).toList();
  }

  Future<Class> getClassByID(String classId) async {
    final classDTO = await _repository.fetchClassById(classId);
    return classDTO.toClass();
  }

}
