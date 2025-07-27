import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/data/endpoint_collection.dart';
import 'package:pat_asl_portal/data/model/dto/class_session_dto.dart';
import 'package:pat_asl_portal/util/exception/api_exception.dart';import 'base_repository.dart';

class SessionRepository {
  final BaseRepository _baseRepository;

  SessionRepository({required BaseRepository baseRepository})
      : _baseRepository = baseRepository;

  /// Fetches active session for a specific class
  ///
  /// Returns a SessionDTO object
  /// Throws [ApiException] if the request fails
  Future<ClassSessionDTO> fetchActiveSession(String classId, String sessionDate, String startTime, String endTime) async {
    try {
      final url = EndpointCollection.activeSessionEndpoint(classId, sessionDate, startTime, endTime);
      final response = await _baseRepository.get(url);
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to fetch active session' : 'Failed to fetch active session',
          response.statusCode,
        );
      }

      return ClassSessionDTO.fromJson(responseData);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch active session: ${e.toString()}', 500);
    }
  }

  Future<void> patchExamType(String classSessionId, String sessionTypeId) async {
    try {
      final url = EndpointCollection.patchExamSession(classSessionId);
      final body = {
        'session_type_id': sessionTypeId,
      };
      final response = await _baseRepository.patch(
        url,
        body,
      );

      if (response.statusCode != 200) {
        final responseData = json.decode(response.body);
        throw ApiException(
          responseData is Map ? responseData['message'] ?? 'Failed to patch exam type' : 'Failed to patch exam type',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to patch exam type: ${e.toString()}', 500);
    }
  }

}