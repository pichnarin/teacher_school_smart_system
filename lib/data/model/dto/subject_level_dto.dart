import 'package:pat_asl_portal/data/model/dto/subject_dto.dart';
import 'package:pat_asl_portal/data/model/subject_level.dart';

class SubjectLevelDTO {
  final String id;
  final SubjectDTO subjectDTO;
  final String name;
  final int levelOrder;

  SubjectLevelDTO({
    required this.id,
    required this.subjectDTO,
    required this.name,
    required this.levelOrder,
  });

  factory SubjectLevelDTO.fromJson(Map<String, dynamic> json) {
    try{
      return SubjectLevelDTO(
        id: json['id'] ?? '',
        subjectDTO: SubjectDTO.fromJson(json['subject'] ?? {}),
        name: json['name'] ?? '',
        levelOrder: json['level_order'] != null ? json['level_order'] as int : 0,
      );
    }catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {

      'id': id,
      'subject': subjectDTO.toJson(),
      'name': name,
      'level_order': levelOrder,
    };
  }

  SubjectLevel toSubjectLevel() {
    return SubjectLevel(
      id: id,
      subject: subjectDTO.toSubject(),
      name: name,
      levelOrder: levelOrder,
    );
  }

  static SubjectLevelDTO fromSubjectLevel(SubjectLevel subjectLevel) {
    return SubjectLevelDTO(
      id: subjectLevel.id,
      subjectDTO: SubjectDTO.fromSubject(subjectLevel.subject),
      name: subjectLevel.name,
      levelOrder: subjectLevel.levelOrder,
    );
  }
}