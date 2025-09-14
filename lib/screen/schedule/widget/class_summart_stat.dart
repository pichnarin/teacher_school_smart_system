import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/model/class_session.dart';
import '../../../util/formatter/time_of_the_day_formater.dart';
import '../../evaluation_section/widget/stat_item.dart';

class ClassesSummaryStats extends StatelessWidget {
  final List<ClassSession> classes;

  const ClassesSummaryStats({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade50, Colors.indigo.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(
            icon: Icons.class_,
            label: 'Total Classes',
            value: classes.length.toString(),
            color: Colors.indigo,
          ),
          Container(height: 40, width: 1, color: Colors.indigo.shade200),
          StatItem(
            icon: Icons.people,
            label: 'Total Students',
            value:
            classes.isEmpty
                ? '0'
                : classes
                .fold<int>(
              0,
                  (sum, cls) => sum + (cls.studentCount ?? 0),
            )
                .toString(),
            color: Colors.green,
          ),
          Container(height: 40, width: 1, color: Colors.indigo.shade200),
          StatItem(
            icon: Icons.schedule,
            label: 'Duration',
            value: _calculateTotalDuration(classes),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  String _calculateTotalDuration(List<ClassSession> classes) {
    if (classes.isEmpty) return '0h';

    final totalMinutes = classes.fold<int>(
      0,
          (sum, cls) =>
      sum +
          TimeFormatter.calculateDurationFromTimeOfDay(
            cls.startTime,
            cls.endTime,
          ),
    );

    final hours = totalMinutes / 60;

    return totalMinutes % 60 == 0
        ? '${hours.toInt()}h'
        : '${hours.toStringAsFixed(1)}h';
  }
}