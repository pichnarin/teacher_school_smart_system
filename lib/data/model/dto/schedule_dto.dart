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
    try {
      final String startTimeStr = json['start_time'] ?? '00:00:00';
      final String endTimeStr = json['end_time'] ?? '00:00:00';

      TimeOfDay parseTime(String timeStr) {
        final parts = timeStr.split(':');
        if (parts.length < 2) throw FormatException('Invalid time format: $timeStr');
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }

      return ScheduleDTO(
        scheduleId: json['id'] ?? '',
        date: DateTime.parse(json['date']),
        startTime: parseTime(startTimeStr),
        endTime: parseTime(endTimeStr),
        subjectDTO: SubjectDTO.fromJson(json['subject']),
        sessionDTO: SessionDTO.fromJson(json['sessionType']),
      );
    } catch (e, stack) {
      print('❌ Failed to parse ScheduleDTO: $e');
      print('🔍 Stack trace:\n$stack');
      print('🧪 Data:\n$json');
      rethrow;
    }
  }


  Map<String, dynamic> toJson() {
    String formatTime(TimeOfDay time) =>
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return {
      'scheduleId': scheduleId,
      'date': date.toIso8601String(),
      'start_time': formatTime(startTime),
      'end_time': formatTime(endTime),
      'subject': subjectDTO.toJson(),
      'sessionType': sessionDTO.toJson(),
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
