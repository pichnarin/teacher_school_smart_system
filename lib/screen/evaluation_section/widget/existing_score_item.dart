import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/score_edit_controls.dart';

class ExistingScoreItem extends StatelessWidget {
  final dynamic student;
  final dynamic score;
  final String scoreId;
  final TextEditingController controller;
  final bool isUpdateMode;
  final Function(String, double) onPatchScore;
  final String? Function(String?) validateScore;

  const ExistingScoreItem({
    super.key,
    required this.student,
    required this.score,
    required this.scoreId,
    required this.controller,
    required this.isUpdateMode,
    required this.onPatchScore,
    required this.validateScore,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Icon(Icons.person, color: colorScheme.onPrimaryContainer),
        ),
        title: Text(
          student.getFullName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Score: ${score.score}'),
        trailing:
        isUpdateMode
            ? ScoreEditControls(
          controller: controller,
          scoreId: scoreId,
          onPatchScore: onPatchScore,
          validateScore: validateScore,
        )
            : null,
      ),
    );
  }
}