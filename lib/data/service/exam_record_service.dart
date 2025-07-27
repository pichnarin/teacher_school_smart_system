import 'package:pat_asl_portal/data/model/dto/score_dto.dart';
import 'package:pat_asl_portal/data/model/score.dart';
import 'package:pat_asl_portal/data/model/score_with_student.dart';
import 'package:pat_asl_portal/data/repository/exam_record_repository.dart';

class ExamRecordService {
  final ExamRecordRepository _recordRepository;

  ExamRecordService({required ExamRecordRepository repository})
      : _recordRepository = repository;

  //is exam score has set already
  Future<bool> isExamScoreSet(String classId, String subjectId, String month, String year) async {
    final response = await _recordRepository.isExamScoreSet(classId, subjectId, month, year);
    final data = response['data'];
    return data is List && data.isNotEmpty;
  }

  /// Fetches exam scores for a specific class with optional filters
  Future<List<ScoreWithStudent>> getExamScores(
      String classId, {
        GetExamScoresFilterDto? filter,
      }) async {
    return await _recordRepository.getExamScores(classId, filter: filter);
  }

  /// Creates exam scores for a class and returns the created scores with student info
  Future<List<ScoreWithStudent>> setExamScores(
      String classId,
      SetExamScoresDto dto,
      ) async {
    _validateSetExamScoresDto(dto);
    return await _recordRepository.setExamScores(classId, dto);
  }

  /// Updates a specific score record
  Future<Score> updateExamScore(
      String classId,
      String scoreId,
      UpdateScoreDto dto,
      ) async {
    _validateUpdateScoreDto(dto);
    return await _recordRepository.updateExamScore(classId, scoreId, dto);
  }

  /// Updates multiple exam scores
  Future<List<Score>> bulkUpdateExamScores(
      String classId,
      List<String> scoreIds,
      List<UpdateScoreDto> updateDtos,
      ) async {
    if (scoreIds.length != updateDtos.length) {
      throw ArgumentError(
        'scoreIds and updateDtos must have the same length',
      );
    }

    final List<Score> results = [];

    for (int i = 0; i < scoreIds.length; i++) {
      final updated = await updateExamScore(
        classId,
        scoreIds[i],
        updateDtos[i],
      );
      results.add(updated);
    }

    return results;
  }

  /// Fetches scores filtered by subject
  Future<List<ScoreWithStudent>> getExamScoresBySubject(
      String classId,
      String subjectId,
      ) async {
    return await getExamScores(
      classId,
      filter: GetExamScoresFilterDto(subjectId: subjectId),
    );
  }

  /// Fetches scores filtered by exam period (month/year)
  Future<List<ScoreWithStudent>> getExamScoresByPeriod(
      String classId,
      int month,
      int year,
      ) async {
    return await getExamScores(
      classId,
      filter: GetExamScoresFilterDto(examMonth: month, examYear: year),
    );
  }

  /// Fetches scores for a specific student
  Future<List<ScoreWithStudent>> getExamScoresByStudent(
      String classId,
      String studentId,
      ) async {
    return await getExamScores(
      classId,
      filter: GetExamScoresFilterDto(studentId: studentId),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 🧪 Validation Helpers
  // ─────────────────────────────────────────────────────────────

  void _validateSetExamScoresDto(SetExamScoresDto dto) {
    if (dto.subjectId.trim().isEmpty) {
      throw ArgumentError('Subject ID is required');
    }

    if (dto.examMonth < 1 || dto.examMonth > 12) {
      throw ArgumentError('Exam month must be between 1 and 12');
    }

    if (dto.examYear < 1900 || dto.examYear > DateTime.now().year + 10) {
      throw ArgumentError('Invalid exam year');
    }

    if (dto.studentScores.isEmpty) {
      throw ArgumentError('Student scores cannot be empty');
    }

    for (final studentScore in dto.studentScores) {
      _validateStudentScoreInput(studentScore);
    }
  }

  void _validateUpdateScoreDto(UpdateScoreDto dto) {
    if (dto.score != null && dto.score! < 0) {
      throw ArgumentError('Score cannot be negative');
    }

    if (dto.maxScore != null && dto.maxScore! <= 0) {
      throw ArgumentError('Max score must be greater than 0');
    }

    if (dto.score != null &&
        dto.maxScore != null &&
        dto.score! > dto.maxScore!) {
      throw ArgumentError('Score cannot exceed max score');
    }
  }

  void _validateStudentScoreInput(StudentScoreInput input) {
    if (input.studentId.trim().isEmpty) {
      throw ArgumentError('Student ID is required');
    }

    if (input.score < 0) {
      throw ArgumentError('Score cannot be negative');
    }

    if (input.maxScore != null) {
      if (input.maxScore! <= 0) {
        throw ArgumentError('Max score must be greater than 0');
      }
      if (input.score > input.maxScore!) {
        throw ArgumentError('Score cannot exceed max score');
      }
    }
  }
}
