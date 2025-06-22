import 'package:pat_asl_portal/data/model/schedule.dart';
import 'package:pat_asl_portal/data/model/teacher.dart';
import 'package:pat_asl_portal/data/model/room.dart';

class Class {
  final String classId;
  final String classGrade;
  final Schedule schedule;
  final Room room;
  final Teacher teacher;

  const Class({
    required this.classId,
    required this.classGrade,
    required this.schedule,
    required this.room,
    required this.teacher,
  });

  String get getClassId => classId;
  String get getClassGrade => classGrade;
  String get getScheduleId => schedule.getScheduleId;
  String get getRoomId => room.getRoomId;
  String get getTeacherId => teacher.getTeacherId;

  @override
  String toString() {
    return 'Class(classId: $classId, classGrade: $classGrade, schedule: $schedule, room: $room, teacher: $teacher)';
  }

}