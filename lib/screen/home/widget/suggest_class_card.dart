import 'package:flutter/material.dart';
import '../../../data/model/session.dart';
import 'package:intl/intl.dart';

class SuggestedClassCard extends StatelessWidget {
  final SessionType sessionType;
  final String classGrade;
  final String classSubject;
  final DateTime classDate;
  final String startTime;
  final String endTime;
  final String? totalStudents;
  final VoidCallback? onTap;

  const SuggestedClassCard({
    super.key,
    required this.sessionType,
    required this.classGrade,
    required this.classSubject,
    required this.classDate,
    required this.startTime,
    required this.endTime,
    this.totalStudents,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMMd().format(classDate);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sessionType.name, // Assuming you override .toString() or use enum extensions
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                    fontSize: 14,
                  ),
                ),
                Icon(Icons.class_, color: Colors.blue.shade300),
              ],
            ),

            const SizedBox(height: 8),

            // Subject and Grade
            Text(
              classSubject,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              'Grade: $classGrade',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // Date and Time
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '$startTime - $endTime',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Students info
            if (totalStudents != null)
              Row(
                children: [
                  const Icon(Icons.group, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    '$totalStudents students enrolled',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
