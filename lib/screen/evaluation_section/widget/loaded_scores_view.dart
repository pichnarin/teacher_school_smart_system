import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/score_statistics_card.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/scores_grid_view.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/scores_list_view.dart';

class LoadedScoresView extends StatelessWidget {
  final List<dynamic> scores;
  final bool isGrid;

  const LoadedScoresView({
    super.key,
    required this.scores,
    required this.isGrid,
  });

  String getGrade(num score) {
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    if (score >= 50) return 'E';
    return 'F';
  }

  Color getGradeColor(String grade, ColorScheme colorScheme) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.amber;
      case 'D':
        return Colors.orange;
      case 'E':
        return Colors.deepOrange;
      default:
        return colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Calculate average score
    final avgScore =
        scores.fold<double>(0, (a, b) => a + b.score.getScore) / scores.length;

    return Column(
      children: [
        ScoreStatisticsCard(
          totalStudents: scores.length,
          averageScore: avgScore,
        ),
        const SizedBox(height: 16),
        isGrid
            ? ScoresGridView(
          scores: scores,
          getGrade: getGrade,
          getGradeColor: getGradeColor,
        )
            : ScoresListView(
          scores: scores,
          getGrade: getGrade,
          getGradeColor: getGradeColor,
        ),
      ],
    );
  }
}