import 'package:flutter/material.dart';
import 'package:pat_asl_portal/data/model/subject.dart';
import 'package:pat_asl_portal/data/model/session.dart';

class Schedule{
  final String scheduleId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Subject subject;
  final Session session;

  const Schedule({
    required this.scheduleId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.session,
  });


  String get getScheduleId => scheduleId;
  String get getDateWithTimeZone => date.toUtc().toIso8601String();
  String get getStartTime => startTime.toString();
  String get getEndTime => endTime.toString();
  String get getSubjectId => subject.subjectId;
  String get getSessionId => session.sessionId;
  SessionType get getSessionName => session.sessionType;

  @override
  String toString() {
    return 'Schedule(scheduleId: $scheduleId, date: $date, startTime: $startTime, endTime: $endTime, subject: $subject, session: $session)';
  }
}