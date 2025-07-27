import 'package:pat_asl_portal/data/model/dto/student_dto.dart';
import '../daily_evaluation.dart';
import 'class_session_dto.dart';

class DailyEvaluationDTO {
  final String id;
  final StudentDTO student;
  final ClassSessionDTO classSession;
  final String homework;
  final String clothing;
  final String attitude;
  final int classActivity;
  final int overallScore;


  const DailyEvaluationDTO({
    required this.id,
    required this.student,
    required this.classSession,
    required this.homework,
    required this.clothing,
    required this.attitude,
    required this.classActivity,
    required this.overallScore,
  });

  factory DailyEvaluationDTO.fromJson(Map<String, dynamic> json) {
    return DailyEvaluationDTO(
      id: json['id'] ?? '',
      student: StudentDTO.fromJson(json['student'] ?? {}),
      classSession: ClassSessionDTO.fromJson(json['classSession'] ?? {}),
      homework: json['homework'] ?? '',
      clothing: json['clothing'] ?? '',
      attitude: json['attitude'] ?? '',
      classActivity: json['class_activity'] ?? 0,
      overallScore: json['overall_score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student.toJson(),
      'class_session': classSession.toJson(),
      'homework': homework,
      'clothing': clothing,
      'attitude': attitude,
      'class_activity': classActivity,
      'overall_score': overallScore,
    };
  }

  DailyEvaluation toDailyEvaluation() {
    return DailyEvaluation(
      id: id,
      student: student.toStudent(),
      classSession: classSession.toClassSession(),
      homework: homework,
      clothing: clothing,
      attitude: attitude,
      classActivity: classActivity,
      overallScore: overallScore,
    );
  }

  static DailyEvaluationDTO fromDailyEvaluation(DailyEvaluation dailyEvaluation) {
    return DailyEvaluationDTO(
      id: dailyEvaluation.id,
      student: StudentDTO.fromStudent(dailyEvaluation.student),
      classSession: ClassSessionDTO.fromClassSession(dailyEvaluation.classSession),
      homework: dailyEvaluation.homework,
      clothing: dailyEvaluation.clothing,
      attitude: dailyEvaluation.attitude,
      classActivity: dailyEvaluation.classActivity,
      overallScore: dailyEvaluation.overallScore,
    );
  }

  @override
  String toString() {
    return 'DailyEvaluationDTO(id: $id, student: $student, classSession: $classSession, homework: $homework, clothing: $clothing, attitude: $attitude, classActivity: $classActivity, overallScore: $overallScore)';
  }
}

class DailyEvaluationPatch {
  final String id;
  final String homework;
  final String clothing;
  final String attitude;
  final int classActivity;

  const DailyEvaluationPatch({
    required this.id,
    required this.homework,
    required this.clothing,
    required this.attitude,
    required this.classActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'homework': homework,
      'clothing': clothing,
      'attitude': attitude,
      'class_activity': classActivity,
    };
  }

  factory DailyEvaluationPatch.fromJson(Map<String, dynamic> json) {
    return DailyEvaluationPatch(
      id: json['id'],
      homework: json['homework'],
      clothing: json['clothing'],
      attitude: json['attitude'],
      classActivity: json['class_activity'],
    );
  }

}

class PatchDailyEvaluationsDto {
  final List<DailyEvaluationPatch> evaluations;

  const PatchDailyEvaluationsDto({required this.evaluations});

  Map<String, dynamic> toJson() {
    return {
      'evaluations': evaluations.map((e) => e.toJson()).toList(),
    };
  }

  factory PatchDailyEvaluationsDto.fromJson(Map<String, dynamic> json) {
    return PatchDailyEvaluationsDto(
      evaluations: (json['evaluations'] as List)
          .map((e) => DailyEvaluationPatch.fromJson(e))
          .toList(),
    );
  }

}

class DailyEvaluationCreateDTO {
  final String studentId;
  final String homework;
  final String clothing;
  final String attitude;
  final int classActivity;

  const DailyEvaluationCreateDTO({
    required this.studentId,
    required this.homework,
    required this.clothing,
    required this.attitude,
    required this.classActivity,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'homework': homework,
      'clothing': clothing,
      'attitude': attitude,
      'class_activity': classActivity,
    };
  }
}
