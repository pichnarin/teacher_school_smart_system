class CreateScoreDto {
  final String studentId;
  final String classId;
  final String subjectId;
  final int examMonth;
  final int examYear;
  final double score;
  final double maxScore;
  final String? remarks;

  const CreateScoreDto({
    required this.studentId,
    required this.classId,
    required this.subjectId,
    required this.examMonth,
    required this.examYear,
    required this.score,
    required this.maxScore,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'class_id': classId,
      'subject_id': subjectId,
      'exam_month': examMonth,
      'exam_year': examYear,
      'score': score,
      'max_score': maxScore,
      'remarks': remarks,
    };
  }
}

class UpdateScoreDto {
  final double? score;
  final double? maxScore;
  final String? remarks;

  const UpdateScoreDto({this.score, this.maxScore, this.remarks});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (score != null) data['score'] = score;
    if (maxScore != null) data['max_score'] = maxScore;
    if (remarks != null) data['remarks'] = remarks;
    return data;
  }
}

class GetExamScoresFilterDto {
  final String? subjectId;
  final int? examMonth;
  final int? examYear;
  final String? studentId;

  const GetExamScoresFilterDto({
    this.subjectId,
    this.examMonth,
    this.examYear,
    this.studentId,
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};
    if (subjectId != null) params['subject_id'] = subjectId!;
    if (examMonth != null) params['exam_month'] = examMonth!.toString();
    if (examYear != null) params['exam_year'] = examYear!.toString();
    if (studentId != null) params['student_id'] = studentId!;
    return params;
  }
}

class SetExamScoresDto {
  final String subjectId;
  final int examMonth;
  final int examYear;
  final double maxScore;
  final List<StudentScoreInput> studentScores;

  const SetExamScoresDto({
    required this.subjectId,
    required this.examMonth,
    required this.examYear,
    required this.maxScore,
    required this.studentScores,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject_id': subjectId,
      'exam_month': examMonth,
      'exam_year': examYear,
      'max_score': maxScore,
      'student_scores': studentScores.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentScoreInput {
  final String studentId;
  final double score;
  final String? remarks;

  const StudentScoreInput({
    required this.studentId,
    required this.score,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {'student_id': studentId, 'score': score, 'remarks': remarks};
  }
}
