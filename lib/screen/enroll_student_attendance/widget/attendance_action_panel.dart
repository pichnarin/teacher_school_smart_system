
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../bloc/enrollment/enrollment_state.dart';
import 'action_button.dart';
import 'error_message_panel.dart';

class AttendanceActionPanel extends StatelessWidget {
  final bool attendanceAlreadyExists;
  final bool hasMarkedAttendance;
  final VoidCallback onSubmit;
  final VoidCallback onToggleUpdateMode;
  final EnrollmentStatus enrollmentStatus;

  const AttendanceActionPanel({
    super.key,
    required this.attendanceAlreadyExists,
    required this.hasMarkedAttendance,
    required this.onSubmit,
    required this.onToggleUpdateMode,
    required this.enrollmentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (!attendanceAlreadyExists && hasMarkedAttendance)
            ActionButton(
              onPressed: onSubmit,
              icon: Icons.save,
              label: 'បញ្ជូនអវត្តមាន',
              color: Colors.teal.shade700,
            ),

          if (attendanceAlreadyExists)
            ActionButton(
              onPressed: onToggleUpdateMode,
              icon: Icons.edit,
              label: 'កែប្រែអវត្តមាន',
              color: Colors.blue.shade700,
            ),

          if (enrollmentStatus == EnrollmentStatus.attendanceError ||
              enrollmentStatus == EnrollmentStatus.patchingError)
            ErrorMessagePanel(
              message: 'មានកំហុសកើតឡើងក្នុងពេលធ្វើប្រតិបត្តិការ។ សូមព្យាយាមម្ដងទៀត។',
            ),
        ],
      ),
    );
  }
}
