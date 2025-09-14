
import 'package:flutter/cupertino.dart';

import 'existing_score_item.dart';

class UpdateScoresList extends StatelessWidget {
  final List<dynamic> scores;
  final bool isUpdateMode;
  final Map<String, TextEditingController> controllers;
  final Function(String, double) onPatchScore;
  final String? Function(String?) validateScore;

  const UpdateScoresList({
    super.key,
    required this.scores,
    required this.isUpdateMode,
    required this.controllers,
    required this.onPatchScore,
    required this.validateScore,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: scores.length,
      itemBuilder: (context, index) {
        final scoreWithStudent = scores[index];
        final student = scoreWithStudent.student;
        final score = scoreWithStudent.score;
        final scoreId = score.scoreId;

        if (!controllers.containsKey(scoreId)) {
          controllers[scoreId] = TextEditingController(
            text: score.score.toString(),
          );
        }
        final controller = controllers[scoreId]!;

        return ExistingScoreItem(
          student: student,
          score: score,
          scoreId: scoreId,
          controller: controller,
          isUpdateMode: isUpdateMode,
          onPatchScore: onPatchScore,
          validateScore: validateScore,
        );
      },
    );
  }
}