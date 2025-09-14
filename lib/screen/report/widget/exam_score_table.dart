import 'package:flutter/material.dart';

import '../../../data/model/score.dart';
import '../../../util/helper_screen/grade.dart';

class ExamScoresTable extends StatelessWidget {
  final List<Score> scores;

  const ExamScoresTable({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 16,
          dataRowMinHeight: 40,
          dataRowMaxHeight: 60,
          columns: const [
            DataColumn(label: Text('Exam Period')),
            DataColumn(label: Text('Score')),
            DataColumn(label: Text('Max')),
            DataColumn(label: Text('Percentage')),
            DataColumn(label: Text('Grade')),
            DataColumn(label: Text('Remarks')),
          ],
          rows:
          scores.map((score) {
            return DataRow(
              cells: [
                DataCell(Text(score.examPeriod)),
                DataCell(Text('${score.score}')),
                DataCell(Text('${score.maxScore}')),
                DataCell(Text('${score.percentage.toStringAsFixed(1)}%')),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getGradeColor(score.grade),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      score.grade,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(score.remarks ?? '-')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}