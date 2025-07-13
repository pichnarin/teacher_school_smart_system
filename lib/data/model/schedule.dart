import 'package:flutter/material.dart';
import 'package:pat_asl_portal/data/model/subject.dart';
import 'package:pat_asl_portal/data/model/session.dart';

class Schedule {
  final String scheduleId;
  final List<String> dayOfWeek; // Updated to represent recurring days
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Subject subject;
  final Session session;

  const Schedule({
    required this.scheduleId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.session,
  });

  String get getScheduleId => scheduleId;
  List<String> get getDayOfWeek => dayOfWeek;
  String get getStartTime => startTime.toString();
  String get getEndTime => endTime.toString();
  String get getSubjectId => subject.subjectId;
  String get getSessionId => session.sessionId;
  SessionType get getSessionName => session.sessionType;

  @override
  String toString() {
    return 'Schedule(scheduleId: $scheduleId, dayOfWeek: $dayOfWeek, startTime: $startTime, endTime: $endTime, subject: $subject, session: $session)';
  }
}