import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/data/repository/class_repository.dart';

class ClassService {
  final ClassRepository _repository;

  ClassService({required ClassRepository repository}) : _repository = repository;

  /// Retrieves all assigned classes
  ///
  /// Returns a list of Class domain objects ready to be used by the UI
  /// Throws exceptions from the repository layer
  Future<List<Class>> getAllAssignedClasses() async {
    final classDTOs = await _repository.fetchAllAssignedClass();



    return classDTOs
        .map((dto) => dto.toClass())
        .toList();
  }

  /// Gets a specific class by ID
  // Future<Class?> getClassById(String classId) async {
  //   final classes = await getAllAssignedClasses();
  //   return classes.firstWhere(
  //         (classItem) => classItem.classId == classId,
  //     orElse: () => null,
  //   );
  // }
}