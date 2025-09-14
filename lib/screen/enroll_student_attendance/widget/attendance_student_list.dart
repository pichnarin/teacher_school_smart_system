import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/enrollment/enrollment_bloc.dart';
import '../../../bloc/enrollment/enrollment_event.dart';
import '../../../bloc/enrollment/enrollment_state.dart';
import 'student_attendane_card.dart';

class AttendanceStudentList extends StatelessWidget {
  final List<dynamic> enrollments;
  final Map<String, String> attendanceRecords; // Changed from dynamic to String
  final bool isUpdateMode;
  final VoidCallback onRefresh;
  final String classId;
  final String classSessionId;

  const AttendanceStudentList({
    super.key,
    required this.enrollments,
    required this.attendanceRecords,
    required this.isUpdateMode,
    required this.onRefresh,
    required this.classId,
    required this.classSessionId,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        onRefresh();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: enrollments.length,
          itemBuilder: (context, index) {
            final enrollment = enrollments[index];
            final student = enrollment.student;
            final studentId = student.id;
            final currentStatus = attendanceRecords[studentId];

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: StudentAttendanceCard(
                fullName: student.getFullName,
                studentId: student.studentNumber,
                selectedStatus: _mapStringToStatus(currentStatus),
                onStatusChanged:
                    (status) =>
                        _updateAttendanceStatus(context, studentId, status),
              ),
            );
          },
        ),
      ),
    );
  }

  AttendanceStatus? _mapStringToStatus(String? status) {
    switch (status) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'late':
        return AttendanceStatus.late;
      default:
        return null;
    }
  }

  String? _mapStatusToString(AttendanceStatus? status) {
    if (status == null) return null;

    switch (status) {
      case AttendanceStatus.present:
        return 'present';
      case AttendanceStatus.absent:
        return 'absent';
      case AttendanceStatus.late:
        return 'late';
    }
  }

  void _updateAttendanceStatus(
    BuildContext context,
    String studentId,
    AttendanceStatus? status,
  ) {
    // Get current state
    final state = context.read<EnrollmentBloc>().state;
    final attendanceAlreadyExists = state.attendanceAlreadyExists == true;

    // Check if we can update this record
    if (attendanceAlreadyExists && !isUpdateMode) {
      return;
    }

    // If status is null, remove the record
    if (status == null) {
      final updatedRecords = Map<String, String>.from(attendanceRecords);
      updatedRecords.remove(studentId);

      context.read<EnrollmentBloc>().emit(
        state.copyWith(attendanceRecords: updatedRecords),
      );
      return;
    }

    // Update the record with new status
    final updatedRecords = Map<String, String>.from(attendanceRecords);
    updatedRecords[studentId] = _mapStatusToString(status)!;

    context.read<EnrollmentBloc>().emit(
      state.copyWith(attendanceRecords: updatedRecords),
    );

    // Only patch if in update mode AND attendance already exists
    if (isUpdateMode && attendanceAlreadyExists) {
      context.read<EnrollmentBloc>().add(
        PatchStudentAttendanceRecord(
          studentId: studentId,
          status: _mapStatusToString(status)!,
        ),
      );
    }
  }
}
