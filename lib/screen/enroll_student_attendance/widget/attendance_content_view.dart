
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../../../bloc/enrollment/enrollment_state.dart';
import 'attendance_action_panel.dart';
import 'attendance_statistics_card.dart';
import 'attendance_student_list.dart';

class AttendanceContentView extends StatelessWidget {
  final List<dynamic> enrollments;
  final Map<String, String> attendanceRecords;
  final bool attendanceAlreadyExists;
  final bool hasMarkedAttendance;
  final bool isUpdateMode;
  final EnrollmentStatus enrollmentStatus;
  final VoidCallback onRefresh;
  final VoidCallback onSubmit;
  final VoidCallback onToggleUpdateMode;
  final String classId;
  final String classSessionId;

  const AttendanceContentView({
    super.key,
    required this.enrollments,
    required this.attendanceRecords,
    required this.attendanceAlreadyExists,
    required this.hasMarkedAttendance,
    required this.isUpdateMode,
    required this.enrollmentStatus,
    required this.onRefresh,
    required this.onSubmit,
    required this.onToggleUpdateMode,
    required this.classId,
    required this.classSessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AttendanceStatisticsCard(
          totalStudents: enrollments.length,
          markedAttendance: attendanceRecords.length,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: AttendanceStudentList(
            enrollments: enrollments,
            attendanceRecords: attendanceRecords,
            isUpdateMode: isUpdateMode,
            onRefresh: onRefresh,
            classId: classId,
            classSessionId: classSessionId,
          ),
        ),
        AttendanceActionPanel(
          attendanceAlreadyExists: attendanceAlreadyExists,
          hasMarkedAttendance: hasMarkedAttendance,
          onSubmit: onSubmit,
          onToggleUpdateMode: onToggleUpdateMode,
          enrollmentStatus: enrollmentStatus,
        ),
      ],
    );
  }
}