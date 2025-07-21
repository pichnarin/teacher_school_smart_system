
import 'package:flutter/material.dart';
import 'package:pat_asl_portal/data/model/class_session.dart';
import 'package:pat_asl_portal/data/model/dto/class_dto.dart';
import 'package:pat_asl_portal/data/model/dto/room_dto.dart';
import 'package:pat_asl_portal/data/model/dto/session_dto.dart';
import 'package:pat_asl_portal/data/model/dto/subject_dto.dart';
import 'package:pat_asl_portal/data/model/session.dart';

import '../room.dart';
import '../subject.dart';

class ClassSessionDTO {
  final String sessionId;
  final String sessionDate;
  final String startTime;
  final String endTime;
  final String status;
  final String? notes;
  final bool isCurrent;
  final Map<String, dynamic> classInfo;
  final int studentCount;
  final RoomDTO room;
  final SubjectDTO subject;
  final SessionDTO sessionType;
  final bool gradingLocked;

  const ClassSessionDTO({
    required this.sessionId,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.isCurrent,
    this.notes,
    required this.classInfo,
    required this.studentCount,
    required this.room,
    required this.subject,
    required this.sessionType,
    required this.gradingLocked,
  });

  factory ClassSessionDTO.fromJson(Map<String, dynamic> json) {
    return ClassSessionDTO(
      sessionId: json['id'] ?? '',
      sessionDate: json['session_date'] ?? '',
      startTime: json['start_time'] ?? '00:00:00',
      endTime: json['end_time'] ?? '00:00:00',
      status: json['status'] ?? 'scheduled',
      notes: json['notes'],
      isCurrent: json['is_current'] ?? false,
      classInfo: json['class'] ?? {},
      studentCount: json['student_count'] ?? 0,
      room: RoomDTO.fromJson(json['room'] ?? {}),
      subject: SubjectDTO.fromJson((json['class']?['subject'] ?? {})),
      sessionType: SessionDTO.fromJson(json['session_type'] ?? {}),
      gradingLocked: json['grading_locked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': sessionId,
      'session_date': sessionDate,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'notes': notes,
      'is_current': isCurrent,
      'class': classInfo,
      'student_count': studentCount,
      'room':  room.toJson(),
      'subject':  subject.toJson(),
      'session_type': sessionType.toJson(),
      'grading_locked': gradingLocked,
    };
  }

  ClassSession toClassSession() {
    TimeOfDay parseTime(String timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    return ClassSession(
      sessionId: sessionId,
      sessionDate: DateTime.parse(sessionDate),
      startTime: parseTime(startTime),
      endTime: parseTime(endTime),
      status: status,
      notes: notes,
      isCurrent: isCurrent,
      classInfo: ClassDTO.fromJson(classInfo).toClass(),
      studentCount: studentCount,
      room: room.toRoom(),
      subject: subject.toSubject(),
      sessionType: sessionType.toSession(),
      gradingLocked: gradingLocked,
    );
  }

  static ClassSessionDTO fromClassSession(ClassSession session) {
    String formatTime(TimeOfDay time) =>
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return ClassSessionDTO(
      sessionId: session.sessionId,
      sessionDate: session.sessionDate.toIso8601String(),
      startTime: formatTime(session.startTime),
      endTime: formatTime(session.endTime),
      status: session.status,
      notes: session.notes,
      isCurrent: session.isCurrent,
      classInfo: ClassDTO.fromClass(session.classInfo).toJson(),
      studentCount: session.studentCount,
      room: RoomDTO.fromRoom(session.room),
      subject: SubjectDTO.fromSubject(session.subject),
      gradingLocked: session.gradingLocked,
      sessionType: SessionDTO.fromSession(session.sessionType), // Pass the Session object
    );
  }
}