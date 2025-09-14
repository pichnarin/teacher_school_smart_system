import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/model/daily_evaluation.dart';

class DailyEvaluationsTable extends StatelessWidget {
  final List<DailyEvaluation> evaluations;

  const DailyEvaluationsTable({super.key, required this.evaluations});

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
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Homework')),
            DataColumn(label: Text('Clothing')),
            DataColumn(label: Text('Attitude')),
            DataColumn(label: Text('Class Activity')),
            DataColumn(label: Text('Overall Score')),
          ],
          rows:
          evaluations.map((evaluation) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    DateFormat(
                      'MM/dd/yyyy',
                    ).format(evaluation.classSession.sessionDate),
                  ),
                ),
                DataCell(_getStatusWidget(evaluation.homework)),
                DataCell(_getStatusWidget(evaluation.clothing)),
                DataCell(_getStatusWidget(evaluation.attitude)),
                DataCell(Text('${evaluation.classActivity}')),
                DataCell(
                  Text(
                    '${evaluation.overallScore}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getScoreColor(evaluation.overallScore),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _getStatusWidget(String status) {
    IconData icon;
    Color color;

    switch (status.toLowerCase()) {
      case 'perfect':
      case 'good':
      case 'excellent':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'fair':
      case 'average':
        icon = Icons.check;
        color = Colors.amber;
        break;
      case 'poor':
      case 'bad':
        icon = Icons.warning;
        color = Colors.red;
        break;
      default:
        icon = Icons.help_outline;
        color = Colors.grey;
    }

    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(status),
      ],
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.amber;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}