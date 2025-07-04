import 'dart:convert';
import 'package:pat_asl_portal/data/endpoint_collection.dart';
import 'package:pat_asl_portal/util/exception/api_exception.dart';
import 'package:pat_asl_portal/data/model/dto/class_dto.dart';
import 'base_repository.dart';

class ClassRepository {
  final BaseRepository _baseRepository;

  ClassRepository({required BaseRepository baseRepository})
      : _baseRepository = baseRepository;

  /// Fetches all assigned classes from the API
  ///
  /// Returns a list of ClassDTO objects
  /// Throws [ApiException] if the request fails
  Future<List<ClassDTO>> fetchAllAssignedClass() async {
    try {
      final response = await _baseRepository.get(EndpointCollection.allClassesEndpoint);

      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to fetch classes' : 'Failed to fetch classes',
          response.statusCode,
        );
      }

      if (responseData is! List) {
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map((json) => ClassDTO.fromJson(json))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch classes: ${e.toString()}', 500);
    }
  }

  Future<List<ClassDTO>> fetchClassByDate(String date) async{
    try{
      final url = EndpointCollection.classByDateEndpoint(date);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to fetch classes by date' : 'Failed to fetch classes by date',
          response.statusCode,
        );
      }

      if(responseData is! List){
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map((json) => ClassDTO.fromJson(json))
          .toList();

    }catch(e){
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch classes by date: ${e.toString()}', 500);
    }
  }

  Future<List<ClassDTO>> fetchClassByRoom(String room) async{
    try{
      final url = EndpointCollection.classByRoomEndpoint(room);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to fetch classes by room' : 'Failed to fetch classes by room',
          response.statusCode,
        );
      }

      if(responseData is! List){
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map((json) => ClassDTO.fromJson(json))
          .toList();

    }catch(e){
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch classes by room: ${e.toString()}', 500);
    }
  }

  Future<List<ClassDTO>> fetchClassByGrade(String grade) async{
    try{
      final url = EndpointCollection.classByGradeEndpoint(grade);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to fetch classes by grade' : 'Failed to fetch classes by grade',
          response.statusCode,
        );
      }

      if(responseData is! List){
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map((json) => ClassDTO.fromJson(json))
          .toList();

    }catch(e){
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch classes by grade: ${e.toString()}', 500);
    }
  }

  Future<ClassDTO> fetchClassById(String classId) async {
    try {
      final url = EndpointCollection.classByIdEndpoint(classId);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to fetch class by ID' : 'Failed to fetch class by ID',
          response.statusCode,
        );
      }

      return ClassDTO.fromJson(responseData);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch class by ID: ${e.toString()}', 500);
    }
  }
}