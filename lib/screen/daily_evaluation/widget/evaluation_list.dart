import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../daily_evaluation_screen.dart';

class EvaluationsList extends StatelessWidget {
  final List<dynamic> evaluations;

  const EvaluationsList({super.key, required this.evaluations});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: evaluations.map((evaluation) =>
          EvaluationListItem(evaluation: evaluation)
      ).toList(),
    );
  }
}

class EvaluationListItem extends StatelessWidget {
  final dynamic evaluation;

  const EvaluationListItem({super.key, required this.evaluation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(evaluation.student.studentNumber),
      subtitle: Text(
        'Score: ${evaluation.homework} - ${evaluation.attitude} - '
            '${evaluation.clothing} - ${evaluation.classActivity} - ${evaluation.overallScore}',
      ),
    );
  }
}