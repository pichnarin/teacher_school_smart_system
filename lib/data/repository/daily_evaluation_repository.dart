import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:pat_asl_portal/data/model/dto/daily_evaluation_dto.dart';
import 'package:pat_asl_portal/data/repository/base_repository.dart';
import '../endpoint_collection.dart';

class DailyEvaluationRepository {
  final BaseRepository _baseRepository;

  DailyEvaluationRepository({required BaseRepository baseRepository})
      : _baseRepository = baseRepository;

  Future<List<DailyEvaluationDTO>> fetchByClassAndDate(
    String classId,
    String sessionDate,
  ) async {
    final url = EndpointCollection.getDailyEvaluation(classId, sessionDate);
    final response = await _baseRepository.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((e) => DailyEvaluationDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch daily evaluations by class and date');
    }
  }

  Future<bool> checkExist(String classSessionId) async {
    final url = EndpointCollection.checkDailyEvaluationEndpoint(classSessionId);
    final response = await _baseRepository.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['exists'] == true;
    } else {
      throw Exception('Failed to check daily evaluation existence');
    }
  }

  Future<void> patchDailyEvaluations(List<Map<String, dynamic>> payload) async {
    final url = EndpointCollection.patchDailyEvaluationEndpoint;
    final body = {
      "evaluations": payload,
    };
    final response = await _baseRepository.patch(url, body);
    if (response.statusCode != 200) {
      throw Exception('Failed to patch daily evaluations');
    }
  }


  Future<void> createDailyEvaluations(
      String classSessionId,
      List<DailyEvaluationCreateDTO> payload,
      ) async {
    final url = EndpointCollection.createDailyEvaluation(classSessionId);

    final jsonArray = jsonEncode(payload.map((e) => e.toJson()).toList());

    final response = await _baseRepository.postRaw(url, jsonArray);

    if (response.statusCode != 201 && response.statusCode != 200) {
      if (kDebugMode) {
        print("❌ Server error: ${response.body}");
      }
      throw Exception('Failed to create daily evaluations');
    }
  }





}
