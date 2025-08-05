import 'package:pat_asl_portal/data/model/subject.dart';
import 'package:pat_asl_portal/data/model/subject_level.dart';
import 'package:pat_asl_portal/data/model/teacher.dart';

class Class {
  final String classId;
  final Teacher teacher;
  final int? studentCount;
  final Subject subject;
  final SubjectLevel subjectLevel;
  // final List<ClassSession> classSessions;

  const Class({
    required this.classId,
    required this.teacher,
    this.studentCount,
    required this.subject,
    required this.subjectLevel,
    // required this.classSessions,
  });

  String get getClassId => classId;
  String get getTeacherId => teacher.getTeacherId;
  int? get getStudentCount => studentCount;
  Subject get getSubject => subject;
  SubjectLevel get getSubjectLevel => subjectLevel;
  // List<ClassSession> get getClassSessions => classSessions;

  @override
  String toString() {
    return 'Class(classId: $classId, teacher: $teacher, studentCount: $studentCount, subject: $subject, subjectLevel: $subjectLevel)';
  }
}