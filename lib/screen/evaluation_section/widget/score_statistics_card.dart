import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/stat_item.dart';

class ScoreStatisticsCard extends StatelessWidget {
  final int totalStudents;
  final double averageScore;

  const ScoreStatisticsCard({
    super.key,
    required this.totalStudents,
    required this.averageScore,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StatItem(
            icon: Icons.people,
            label: 'ចំនួនសិស្ស',
            value: totalStudents.toString(),
            color: colorScheme.primary,
          ),
          Container(
            height: 40,
            width: 1,
            color: colorScheme.primary.withOpacity(0.2),
          ),
          StatItem(
            icon: Icons.star,
            label: 'បន្ទុះមធ្យម',
            value: averageScore.toStringAsFixed(1),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}