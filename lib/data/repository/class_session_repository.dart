import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/data/endpoint_collection.dart';
import 'package:pat_asl_portal/util/exception/api_exception.dart';
import '../model/dto/class_session_dto.dart';
import 'base_repository.dart';

class ClassSessionRepository {
  final BaseRepository _baseRepository;

  ClassSessionRepository({required BaseRepository baseRepository})
      : _baseRepository = baseRepository;

  /// Fetches all assigned classes from the API
  ///
  /// Returns a list of ClassDTO objects
  /// Throws [ApiException] if the request fails
  Future<List<ClassSessionDTO>> fetchAllClassSessions() async {
    try {
      final response = await _baseRepository.get(EndpointCollection.allClassSessionEndpoint);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to fetch class sessions' : 'Failed to fetch class sessions',
          response.statusCode,
        );
      }

      if (responseData is! List) {
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map<ClassSessionDTO>((json) => ClassSessionDTO.fromJson(json))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch class sessions: ${e.toString()}', 500);
    }
  }


  Future<List<ClassSessionDTO>> fetchClassSessionByDate(String date) async{
    try{
      final url = EndpointCollection.classSessionByDateEndpoint(date);
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
          .map<ClassSessionDTO>((json) => ClassSessionDTO.fromJson(json))
          .toList();

    }catch(e){
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch classes by date: ${e.toString()}', 500);
    }
  }

  Future<List<ClassSessionDTO>> fetchClassSessionByRoom(String room) async{
    try{
      final url = EndpointCollection.classSessionByRoomEndpoint(room);
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
          .map<ClassSessionDTO>((json) => ClassSessionDTO.fromJson(json))
          .toList();

    }catch(e){
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch classes by room: ${e.toString()}', 500);
    }
  }

  Future<List<ClassSessionDTO>> fetchClassSessionByGrade(String grade) async{
    try{
      final url = EndpointCollection.classSessionByGradeEndpoint(grade);
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
          .map<ClassSessionDTO>((json) => ClassSessionDTO.fromJson(json))
          .toList();

    }catch(e){
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch classes by grade: ${e.toString()}', 500);
    }
  }

  Future<List<ClassSessionDTO>> fetchClassSessionById(String classId) async {
    try {
      final url = EndpointCollection.classSessionByIdEndpoint(classId);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to fetch class by ID' : 'Failed to fetch class by ID',
          response.statusCode,
        );
      }

      if (responseData is! List) {
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map<ClassSessionDTO>((json) => ClassSessionDTO.fromJson(json as Map<String, dynamic>))
          .toList();

    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch class by ID: ${e.toString()}', 500);
    }
  }

}



