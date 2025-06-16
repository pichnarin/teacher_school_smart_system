import 'package:pat_asl_portal/data/model/subject.dart';

class SubjectDTO {
  final String subjectId;
  final String subjectName;

  SubjectDTO({
    required this.subjectId,
    required this.subjectName,
  });

  factory SubjectDTO.fromJson(Map<String, dynamic> json) {
    return SubjectDTO(
      subjectId: json['id'] as String,
      subjectName: json['subject_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': subjectId,
      'name': subjectName,
    };
  }

  Subject toSubject() {
    return Subject(
      subjectId: subjectId,
      subjectName: subjectName,
    );
  }

  static SubjectDTO fromSubject(Subject subject) {
    return SubjectDTO(
      subjectId: subject.subjectId,
      subjectName: subject.subjectName,
    );
  }
}