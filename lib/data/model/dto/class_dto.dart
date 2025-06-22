import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/data/model/dto/room_dto.dart';
import 'package:pat_asl_portal/data/model/dto/schedule_dto.dart';
import 'package:pat_asl_portal/data/model/dto/teacher_dto.dart';

class ClassDTO{
  final String classId;
  final String classGrade;
  final ScheduleDTO scheduleDTO;
  final RoomDTO roomDTO;
  final TeacherDTO teacherDTO;

  const ClassDTO({
    required this.classId,
    required this.classGrade,
    required this.scheduleDTO,
    required this.roomDTO,
    required this.teacherDTO,
  });

  factory ClassDTO.fromJson(Map<String, dynamic> json) {
    try {
      return ClassDTO(
        classId: json['id'] ?? '',
        classGrade: json['grade'] ?? '',
        scheduleDTO: ScheduleDTO.fromJson(json['schedule']),
        roomDTO: RoomDTO.fromJson(json['room']),
        teacherDTO: TeacherDTO.fromJson(json['teacher']),
      );
    } catch (e, stack) {
      print('❌ Failed to parse ClassDTO: $e');
      print('🔍 Stack trace:\n$stack');
      print('🧪 Data:\n$json');
      rethrow;
    }
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

  Class toClass() {
    return Class(
      classId: classId,
      classGrade: classGrade,
      schedule: scheduleDTO.toSchedule(),
      room: roomDTO.toRoom(),
      teacher: teacherDTO.toTeacher(),
    );
  }

  static ClassDTO fromClass(Class classes) {
    return ClassDTO(
      classId: classes.classId,
      classGrade: classes.classGrade,
      scheduleDTO: ScheduleDTO.fromSchedule(classes.schedule),
      roomDTO: RoomDTO.fromRoom(classes.room),
      teacherDTO: TeacherDTO.fromTeacher(classes.teacher),
    );
  }
}

