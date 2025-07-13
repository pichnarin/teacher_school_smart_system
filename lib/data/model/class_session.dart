
import 'package:flutter/material.dart';
import 'package:pat_asl_portal/data/model/class.dart';

class ClassSession {
  final String sessionId;
  final DateTime sessionDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String status;
  final String? notes;
  final bool isCurrent;
  final Class classInfo;
  final int studentCount;

  const ClassSession({
    required this.sessionId,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.notes,
    required this.isCurrent,
    required this.classInfo,
    required this.studentCount,
  });

  String get getSessionId => sessionId;
  DateTime get getSessionDate => sessionDate;
  TimeOfDay get getStartTime => startTime;
  TimeOfDay get getEndTime => endTime;
  String get getStatus => status;
  String? get getNotes => notes;
  bool get getIsCurrent => isCurrent;
  Class get getClassInfo => classInfo;
  int get getStudentCount => studentCount;

  @override
  String toString() {
    return 'ClassSession(sessionId: $sessionId, sessionDate: $sessionDate, startTime: $startTime, endTime: $endTime, status: $status, studentCount: $studentCount, classInfo: $classInfo)';
  }
}
