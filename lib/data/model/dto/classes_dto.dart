import 'package:pat_asl_portal/data/model/classes.dart';
import 'package:pat_asl_portal/data/model/dto/room_dto.dart';
import 'package:pat_asl_portal/data/model/dto/schedule_dto.dart';
import 'package:pat_asl_portal/data/model/dto/teacher_dto.dart';

class ClassesDTO{
  final String classId;
  final String classGrade;
  final ScheduleDTO scheduleDTO;
  final RoomDTO roomDTO;
  final TeacherDTO teacherDTO;

  const ClassesDTO({
    required this.classId,
    required this.classGrade,
    required this.scheduleDTO,
    required this.roomDTO,
    required this.teacherDTO,
  });

  factory ClassesDTO.fromJson(Map<String, dynamic> json) {
    return ClassesDTO(
      classId: json['classId'] ?? '',
      classGrade: json['classGrade'] ?? '',
      scheduleDTO: ScheduleDTO.fromJson(json['schedule']),
      roomDTO: RoomDTO.fromJson(json['room']),
      teacherDTO: TeacherDTO.fromJson(json['teacher']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classId': classId,
      'classGrade': classGrade,
      'schedule': scheduleDTO.toJson(),
      'room': roomDTO.toJson(),
      'teacher': teacherDTO.toJson(),
    };
  }

  Classes toClass() {
    return Classes(
      classId: classId,
      classGrade: classGrade,
      schedule: scheduleDTO.toSchedule(),
      room: roomDTO.toRoom(),
      teacher: teacherDTO.toTeacher(),
    );
  }

  static ClassesDTO fromClass(Classes classes) {
    return ClassesDTO(
      classId: classes.classId,
      classGrade: classes.classGrade,
      scheduleDTO: ScheduleDTO.fromSchedule(classes.schedule),
      roomDTO: RoomDTO.fromRoom(classes.room),
      teacherDTO: TeacherDTO.fromTeacher(classes.teacher),
    );
  }
}

