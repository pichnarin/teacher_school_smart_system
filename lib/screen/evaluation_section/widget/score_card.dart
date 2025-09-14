
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final dynamic score;
  final String Function(num) getGrade;
  final Color Function(String, ColorScheme) getGradeColor;

  const ScoreCard({
    super.key,
    required this.score,
    required this.getGrade,
    required this.getGradeColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final grade = getGrade(score.score.maxScore);
    final gradeColor = getGradeColor(grade, colorScheme);

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: gradeColor,
              child: Text(
                grade,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    score.student.getFullName,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Score: ${score.score.getScore.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}