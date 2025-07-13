import 'package:pat_asl_portal/data/model/schedule.dart';
import 'package:pat_asl_portal/data/model/teacher.dart';
import 'package:pat_asl_portal/data/model/room.dart';
import 'package:pat_asl_portal/data/model/class_session.dart';

class Class {
  final String classId;
  final String classGrade;
  final Schedule schedule;
  final Room room;
  final Teacher teacher;
  // final int? studentCount;
  // final List<ClassSession> classSessions;

  const Class({
    required this.classId,
    required this.classGrade,
    required this.schedule,
    required this.room,
    required this.teacher,
    // this.studentCount,
    // required this.classSessions,
  });

  String get getClassId => classId;
  String get getClassGrade => classGrade;
  String get getScheduleId => schedule.getScheduleId;
  String get getRoomId => room.getRoomId;
  String get getTeacherId => teacher.getTeacherId;
  // int? get getStudentCount => studentCount;
  // List<ClassSession> get getClassSessions => classSessions;

  @override
  String toString() {
    return 'Class(classId: $classId, classGrade: $classGrade, schedule: $schedule, room: $room, teacher: $teacher)';
  }
}