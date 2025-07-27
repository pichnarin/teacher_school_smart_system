import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/data/endpoint_collection.dart';
import 'package:pat_asl_portal/data/model/student_report.dart';
import 'package:pat_asl_portal/util/exception/api_exception.dart';
import '../model/dto/class_dto.dart';
import 'base_repository.dart';

class ClassRepository {
  final BaseRepository _baseRepository;

  ClassRepository({required BaseRepository baseRepository})
    : _baseRepository = baseRepository;

  /// Fetches all assigned classes from the API
  ///
  /// Returns a list of ClassDTO objects
  /// Throws [ApiException] if the request fails
  Future<List<ClassDTO>> fetchAllClasses() async {
    try {
      final response = await _baseRepository.get(
        EndpointCollection.allClassesEndpoint,
      );
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        throw ApiException(
          responseData is Map
              ? responseData['message'] ?? 'Failed to fetch class sessions'
              : 'Failed to fetch class sessions',
          response.statusCode,
        );
      }

      if (responseData is! List) {
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map<ClassDTO>((json) => ClassDTO.fromJson(json))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to fetch class sessions: ${e.toString()}',
        500,
      );
    }
  }

  Future<List<ClassDTO>> fetchClassByDate(String date) async {
    try {
      final url = EndpointCollection.classByDateEndpoint(date);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      debugPrint('Response date Data: $responseData');

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw ApiException(
          responseData is Map
              ? responseData['message'] ?? 'Failed to fetch classes by date'
              : 'Failed to fetch classes by date',
          response.statusCode,
        );
      }

      if (responseData is! List) {
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map<ClassDTO>((json) => ClassDTO.fromJson(json))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to fetch classes by date: ${e.toString()}',
        500,
      );
    }
  }

  Future<List<ClassDTO>> fetchClassByRoom(String room) async {
    try {
      final url = EndpointCollection.classByRoomEndpoint(room);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw ApiException(
          responseData is Map
              ? responseData['message'] ?? 'Failed to fetch classes by room'
              : 'Failed to fetch classes by room',
          response.statusCode,
        );
      }

      if (responseData is! List) {
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map<ClassDTO>((json) => ClassDTO.fromJson(json))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to fetch classes by room: ${e.toString()}',
        500,
      );
    }
  }

  Future<List<ClassDTO>> fetchClassByGrade(String grade) async {
    try {
      final url = EndpointCollection.classByGradeEndpoint(grade);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw ApiException(
          responseData is Map
              ? responseData['message'] ?? 'Failed to fetch classes by grade'
              : 'Failed to fetch classes by grade',
          response.statusCode,
        );
      }

      if (responseData is! List) {
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map<ClassDTO>((json) => ClassDTO.fromJson(json))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to fetch classes by grade: ${e.toString()}',
        500,
      );
    }
  }

  Future<List<ClassDTO>> fetchClassById(String classId) async {
    try {
      final url = EndpointCollection.classByIdEndpoint(classId);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        throw ApiException(
          responseData is Map
              ? responseData['message'] ?? 'Failed to fetch class by ID'
              : 'Failed to fetch class by ID',
          response.statusCode,
        );
      }

      if (responseData is! List) {
        throw ApiException('Unexpected response format', response.statusCode);
      }

      return responseData
          .map<ClassDTO>(
            (json) => ClassDTO.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch class by ID: ${e.toString()}', 500);
    }
  }

  Future<List<StudentReportDTO>> fetchStudentReport(
      String classId,
      String month,
      String year,
      ) async {
    try {
      final url = EndpointCollection.studentReportEndpoint(
        classId,
        month,
        year,
      );
      final response = await _baseRepository.get(url);

      if (response.body == null) {
        throw ApiException(
          'Empty response body from server',
          response.statusCode,
        );
      }

      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        final message =
        responseData is Map
            ? responseData['message'] ?? 'Unknown error'
            : 'Non-200 response';
        throw ApiException('Server Error: $message', response.statusCode);
      }

      if (responseData == null) {
        throw ApiException('Decoded response is null', response.statusCode);
      }

      if (responseData is! List) {
        throw ApiException(
          'Expected a list but got ${responseData.runtimeType}',
          response.statusCode,
        );
      }

      final List<StudentReportDTO> resultList = [];

      for (int i = 0; i < responseData.length; i++) {
        final item = responseData[i];

        if (item == null) {
          continue;
        }

        if (item is! Map<String, dynamic>) {
          throw ApiException(
            'Invalid entry type at index $i: Expected Map<String, dynamic> but got ${item.runtimeType}',
            500,
          );
        }

        try {
          resultList.add(StudentReportDTO.fromJson(item));
        } catch (e) {
          throw ApiException(
            'Failed to parse student report at index $i: $e',
            500,
          );
        }
      }

      return resultList;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Unexpected error while fetching student report: ${e.runtimeType} - ${e.toString()}',
        500,
      );
    }
  }


}
