import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/model/student_report.dart';
import 'attendance_indicator.dart';

class AttendanceSummary extends StatelessWidget {
  final AttendanceReport attendanceReport;

  const AttendanceSummary({super.key, required this.attendanceReport});

  @override
  Widget build(BuildContext context) {
    final total =
        attendanceReport.present +
            attendanceReport.late +
            attendanceReport.absent +
            attendanceReport.excused;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AttendanceIndicator(
              label: 'Present',
              count: attendanceReport.present,
              color: Colors.green,
            ),
            AttendanceIndicator(
              label: 'Late',
              count: attendanceReport.late,
              color: Colors.amber,
            ),
            AttendanceIndicator(
              label: 'Absent',
              count: attendanceReport.absent,
              color: Colors.red,
            ),
            AttendanceIndicator(
              label: 'Excused',
              count: attendanceReport.excused,
              color: Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (total > 0)
          LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
            minHeight: 8,
          ),
        if (total > 0)
          Stack(
            children: [
              LinearProgressIndicator(
                value: attendanceReport.present / total,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 8,
              ),
              LinearProgressIndicator(
                value:
                (attendanceReport.present + attendanceReport.late) / total,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                minHeight: 8,
              ),
              LinearProgressIndicator(
                value:
                (attendanceReport.present +
                    attendanceReport.late +
                    attendanceReport.absent) /
                    total,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 8,
              ),
            ],
          ),
        const SizedBox(height: 8),
        Text(
          'Total Sessions: $total',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}