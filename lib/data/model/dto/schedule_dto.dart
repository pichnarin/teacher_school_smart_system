import 'package:flutter/material.dart';
import 'package:pat_asl_portal/data/model/dto/subject_dto.dart';
import 'package:pat_asl_portal/data/model/dto/session_dto.dart';
import '../schedule.dart';

class ScheduleDTO {
  final String scheduleId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final SubjectDTO subjectDTO;
  final SessionDTO sessionDTO;

  const ScheduleDTO({
    required this.scheduleId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.subjectDTO,
    required this.sessionDTO,
  });

  factory ScheduleDTO.fromJson(Map<String, dynamic> json) {
    return ScheduleDTO(
      scheduleId: json['scheduleId'] ?? '',
      date: DateTime.parse(json['date']),
      startTime: TimeOfDay(
        hour: json['start_time']['hour'],
        minute: json['start_time']['minute'],
      ),
      endTime: TimeOfDay(
        hour: json['end_time']['hour'],
        minute: json['end_time']['minute'],
      ),
      subjectDTO: SubjectDTO.fromJson(json['subject']),
      sessionDTO: SessionDTO.fromJson(json['session']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleId': scheduleId,
      'date': date.toIso8601String(),
      'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
      'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
      'subject': subjectDTO.toJson(),
      'session': sessionDTO.toJson(),
    };
  }

  Schedule toSchedule() {
    return Schedule(
      scheduleId: scheduleId,
      date: date,
      startTime: startTime,
      endTime: endTime,
      subject: subjectDTO.toSubject(),
      session: sessionDTO.toSession(),
    );
  }

  static ScheduleDTO fromSchedule(Schedule schedule) {
    return ScheduleDTO(
      scheduleId: schedule.scheduleId,
      date: schedule.date,
      startTime: schedule.startTime,
      endTime: schedule.endTime,
      subjectDTO: SubjectDTO.fromSubject(schedule.subject),
      sessionDTO: SessionDTO.fromSession(schedule.session),
    );
  }
}