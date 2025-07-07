import 'package:pat_asl_portal/data/model/dto/student_dto.dart';

import 'dto/subject_dto.dart';
import 'score.dart';
import 'student.dart';
import 'subject.dart';

class ScoreWithStudent {
  final Score score;
  final Student student;
  final Subject subject;

  const ScoreWithStudent({
    required this.score,
    required this.student,
    required this.subject,
  });

  factory ScoreWithStudent.fromJson(Map<String, dynamic> json) {
    return ScoreWithStudent(
      score: Score.fromJson(json['score'] as Map<String, dynamic>),
      student: StudentDTO.fromJson(json['student'] as Map<String, dynamic>).toStudent(),
      subject: SubjectDTO.fromJson(json['subject'] as Map<String, dynamic>).toSubject(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score.toJson(),
      'student': StudentDTO.fromStudent(student).toJson(),
      'subject': SubjectDTO.fromSubject(subject).toJson(),
    };
  }
}