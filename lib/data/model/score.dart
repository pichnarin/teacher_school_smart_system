class Score {
  final String scoreId;
  final String studentId;
  final String classId;
  final String subjectId;
  final int examMonth;
  final int examYear;
  final double score;
  final double maxScore;
  final String? remarks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Score({
    required this.scoreId,
    required this.studentId,
    required this.classId,
    required this.subjectId,
    required this.examMonth,
    required this.examYear,
    required this.score,
    required this.maxScore,
    this.remarks,
    required this.createdAt,
    required this.updatedAt,
  });

  double get percentage => (score / maxScore) * 100;

  String get grade {
    final percentage = this.percentage;
    if (percentage >= 90) return 'A';
    if (percentage >= 80) return 'B';
    if (percentage >= 70) return 'C';
    if (percentage >= 60) return 'D';
    return 'F';
  }

  String get examPeriod => '$examMonth/$examYear';

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      scoreId: json['score_id'] as String,
      studentId: json['student_id'] as String,
      classId: json['class_id'] as String,
      subjectId: json['subject_id'] as String,
      examMonth: json['exam_month'] as int,
      examYear: json['exam_year'] as int,
      score: (json['score'] as num).toDouble(),
      maxScore: (json['max_score'] as num).toDouble(),
      remarks: json['remarks'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score_id': scoreId,
      'student_id': studentId,
      'class_id': classId,
      'subject_id': subjectId,
      'exam_month': examMonth,
      'exam_year': examYear,
      'score': score,
      'max_score': maxScore,
      'remarks': remarks,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Score copyWith({
    String? scoreId,
    String? studentId,
    String? classId,
    String? subjectId,
    int? examMonth,
    int? examYear,
    double? score,
    double? maxScore,
    String? remarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Score(
      scoreId: scoreId ?? this.scoreId,
      studentId: studentId ?? this.studentId,
      classId: classId ?? this.classId,
      subjectId: subjectId ?? this.subjectId,
      examMonth: examMonth ?? this.examMonth,
      examYear: examYear ?? this.examYear,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}