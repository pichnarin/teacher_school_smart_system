import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/data/endpoint_collection.dart';
import 'package:pat_asl_portal/data/model/dto/score_dto.dart';
import 'package:pat_asl_portal/data/model/score.dart';
import 'package:pat_asl_portal/data/model/score_with_student.dart';
import 'package:pat_asl_portal/util/exception/api_exception.dart';
import 'base_repository.dart';

class ExamRecordRepository {
  final BaseRepository _baseRepository;

  ExamRecordRepository({required BaseRepository baseRepository})
      : _baseRepository = baseRepository;

  //is exam score already set?
  Future<Map<String, dynamic>> isExamScoreSet(String classId, String subjectId, String examMonth, String examYear) async {
    try {
      final url = EndpointCollection.isExamScoresExisted(classId, subjectId, examMonth, examYear);
      final response = await _baseRepository.get(url);
      final responseData = _decodeResponse(response);

      if (response.statusCode != 200) {
        throw ApiException(
          responseData['message'] ?? 'Failed to check exam score status',
          response.statusCode,
        );
      }

      return responseData as Map<String, dynamic>;
    } catch (e) {
      _handleError(e, 'check exam score status');
    }
  }

  /// Fetches exam scores with optional filters
  Future<List<ScoreWithStudent>> getExamScores(
      String classId, {
        GetExamScoresFilterDto? filter,
      }) async {
    try {
      String url = EndpointCollection.getExamScoresEndpoint(classId);

      if (filter != null) {
        final params = filter.toQueryParams();
        if (params.isNotEmpty) {
          final uri = Uri.parse(url);
          url = uri.replace(queryParameters: {
            ...uri.queryParameters,
            ...params,
          }).toString();
        }
      }

      final response = await _baseRepository.get(url);
      final responseData = _decodeResponse(response);

      debugPrint('Exam scores response: $responseData');

      final List<dynamic> scoresData = _extractListData(responseData);

      return scoresData
          .map((json) => ScoreWithStudent.fromJson(json))
          .toList();
    } catch (e) {
      _handleError(e, 'fetch exam scores');
    }
  }

  /// Creates new exam scores
  Future<List<ScoreWithStudent>> setExamScores(
      String classId,
      SetExamScoresDto dto,
      ) async {
    try {
      final url = EndpointCollection.setExamScoresEndpoint(classId);
      final response = await _baseRepository.post(url, body: dto.toJson());
      final responseData = _decodeResponse(response);

      // debugPrint('From repository');
      // debugPrint(classId);
      // debugPrint(dto.toJson().toString());
      // debugPrint(responseData.toString());

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          _extractMessage(responseData) ?? 'Failed to set exam scores',
          response.statusCode,
        );
      }

      // If API doesn't return data, fetch the created scores based on input
      if (responseData is Map &&
          responseData.containsKey('message') &&
          !responseData.containsKey('data')) {
        return getExamScores(
          classId,
          filter: GetExamScoresFilterDto(
            subjectId: dto.subjectId,
            examMonth: dto.examMonth,
            examYear: dto.examYear,
          ),
        );
      }

      final List<dynamic> scoresData = _extractListData(responseData);

      return scoresData
          .map((json) => ScoreWithStudent.fromJson(json))
          .toList();
    } catch (e) {
      _handleError(e, 'set exam scores');
    }
  }

  /// Updates a single exam score
  Future<Score> updateExamScore(
      String classId,
      String scoreId,
      UpdateScoreDto dto,
      ) async {
    try {
      final url = EndpointCollection.patchExamScoresEndpoint(classId, scoreId);

      final response = await _baseRepository.patch(url, dto.toJson());
      final responseData = _decodeResponse(response);

      if (response.statusCode != 200) {
        throw ApiException(
          _extractMessage(responseData) ?? 'Failed to update exam score',
          response.statusCode,
        );
      }

      final Map<String, dynamic> scoreData = _extractObjectData(responseData);

      return Score.fromJson(scoreData);
    } catch (e) {
      _handleError(e, 'update exam score');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 📦 Utility Functions
  // ─────────────────────────────────────────────────────────────

  dynamic _decodeResponse(dynamic response) {
    return json.decode(response.body);
  }

  List<dynamic> _extractListData(dynamic responseData) {
    if (responseData is Map && responseData.containsKey('data')) {
      return responseData['data'] as List;
    } else if (responseData is List) {
      return responseData;
    } else {
      throw ApiException('Unexpected response format', 500);
    }
  }

  Map<String, dynamic> _extractObjectData(dynamic responseData) {
    if (responseData is Map && responseData.containsKey('data')) {
      return Map<String, dynamic>.from(responseData['data'] as Map);
    } else if (responseData is Map) {
      return Map<String, dynamic>.from(responseData);
    } else {
      throw ApiException('Unexpected response format', 500);
    }
  }

  String? _extractMessage(dynamic responseData) {
    return responseData is Map ? responseData['message'] : null;
  }

  Never _handleError(dynamic e, String action) {
    if (e is ApiException) throw e;
    throw ApiException('Failed to $action: ${e.toString()}', 500);
  }
}
