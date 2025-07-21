// models/dto/class_dto.dart

import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/data/model/dto/room_dto.dart';
import 'package:pat_asl_portal/data/model/dto/schedule_dto.dart';
import 'package:pat_asl_portal/data/model/dto/subject_dto.dart';
import 'package:pat_asl_portal/data/model/dto/subject_level_dto.dart';
import 'package:pat_asl_portal/data/model/dto/teacher_dto.dart';
import 'package:pat_asl_portal/data/model/subject_level.dart';

class ClassDTO {
  final String classId;
  final TeacherDTO teacherDTO;
  final int? studentCount;
  final SubjectLevelDTO subjectLevelDTO;
  final SubjectDTO subjectDTO;

  const ClassDTO({
    required this.classId,
    required this.teacherDTO,
    this.studentCount,
    required this.subjectLevelDTO,
    required this.subjectDTO,
  });

  factory ClassDTO.fromJson(Map<String, dynamic> json) {
    return ClassDTO(
      classId: json['id'] ?? '',
      teacherDTO: TeacherDTO.fromJson(json['teacher'] ?? {}),
      studentCount: json['student_count'] != null ? json['student_count'] as int : null,
      subjectLevelDTO: SubjectLevelDTO.fromJson(json['subjectLevel'] ?? {}),
      subjectDTO: SubjectDTO.fromJson(json['subject'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': classId,
      'teacher': teacherDTO.toJson(),
      'student_count': studentCount,
      'subject_level': subjectLevelDTO.toJson(),
      'subject': subjectDTO.toJson(),
    };
  }

  Class toClass() {
    return Class(
      classId: classId,
      teacher: teacherDTO.toTeacher(),
      studentCount: studentCount,
      subjectLevel: subjectLevelDTO.toSubjectLevel(),
      subject: subjectDTO.toSubject(),
    );
  }

  static ClassDTO fromClass(Class classes) {
    return ClassDTO(
      classId: classes.classId,
      teacherDTO: TeacherDTO.fromTeacher(classes.teacher),
      studentCount: classes.studentCount,
      subjectLevelDTO: SubjectLevelDTO.fromSubjectLevel(classes.subjectLevel),
      subjectDTO: SubjectDTO.fromSubject(classes.subject),
    );
  }
}
