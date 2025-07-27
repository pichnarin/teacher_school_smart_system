import 'dart:developer' as developer;
import '../repository/daily_evaluation_repository.dart';
import '../model/dto/daily_evaluation_dto.dart';

class DailyEvaluationService {
  final DailyEvaluationRepository _dailyEvaluationRepository;

  DailyEvaluationService({required DailyEvaluationRepository dailyEvaluationRepository})
      : _dailyEvaluationRepository = dailyEvaluationRepository;

  Future<List<DailyEvaluationDTO>> fetchByClassAndDate(String classId, String sessionDate) async {
    try {
      return await _dailyEvaluationRepository.fetchByClassAndDate(classId, sessionDate);
    } catch (e, stack) {
      developer.log('fetchByClassAndDate error: $e', stackTrace: stack);
      rethrow;
    }
  }

  Future<bool> checkExist(String classSessionId) async {
    try {
      return await _dailyEvaluationRepository.checkExist(classSessionId);
    } catch (e, stack) {
      developer.log('checkExist error: $e', stackTrace: stack);
      rethrow;
    }
  }

  Future<void> patchDailyEvaluations(List<Map<String, dynamic>> payload) async {
    try {
      await _dailyEvaluationRepository.patchDailyEvaluations(payload);
    } catch (e, stack) {
      developer.log('patchDailyEvaluations error: $e', stackTrace: stack);
      rethrow;
    }
  }

  Future<void> createDailyEvaluations(String classSessionId, List<DailyEvaluationCreateDTO> payload) async {
    try {
      await _dailyEvaluationRepository.createDailyEvaluations(classSessionId, payload);
    } catch (e, stack) {
      developer.log('createDailyEvaluations error: $e', stackTrace: stack);
      rethrow;
    }
  }
}