
import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/enroll_student_attendance/widget/statistic_item.dart';

class AttendanceStatisticsCard extends StatelessWidget {
  final int totalStudents;
  final int markedAttendance;

  const AttendanceStatisticsCard({
    super.key,
    required this.totalStudents,
    required this.markedAttendance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade50, Colors.teal.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatisticItem(
            icon: Icons.people,
            label: 'ចំនួនសិស្ស',
            value: totalStudents.toString(),
            color: Colors.teal,
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.teal.shade200,
          ),
          StatisticItem(
            icon: Icons.check_circle,
            label: 'បានកំណត់',
            value: markedAttendance.toString(),
            color: Colors.green,
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.teal.shade200,
          ),
          StatisticItem(
            icon: Icons.pending,
            label: 'រង់ចាំការកំណត់',
            value: (totalStudents - markedAttendance).toString(),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}