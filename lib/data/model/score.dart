import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/data/model/student.dart';

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
  });

  double get percentage => (score / maxScore) * 100;
  double get getScore => score;

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
      scoreId: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      classId: json['class_id']?.toString() ?? '',
      subjectId: json['subject_id']?.toString() ?? '',
      examMonth: json['exam_month'] ?? 0,
      examYear: json['exam_year'] ?? 0,
      score: (json['score'] ?? 0).toDouble(),
      maxScore: (json['max_score'] ?? 0).toDouble(),
      remarks: json['remarks']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': scoreId,
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

    );
  }

  @override
  String toString() {
    return 'Score(scoreId: $scoreId, studentId: $studentId, classId: $classId, subjectId: $subjectId, examMonth: $examMonth, examYear: $examYear, score: $score, maxScore: $maxScore, remarks: $remarks)';
  }
}
