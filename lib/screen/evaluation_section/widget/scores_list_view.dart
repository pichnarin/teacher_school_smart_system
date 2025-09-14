
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/score_card.dart';

class ScoresListView extends StatelessWidget {
  final List<dynamic> scores;
  final String Function(num) getGrade;
  final Color Function(String, ColorScheme) getGradeColor;

  const ScoresListView({
    super.key,
    required this.scores,
    required this.getGrade,
    required this.getGradeColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: scores.length,
      itemBuilder:
          (context, index) => ScoreCard(
        score: scores[index],
        getGrade: getGrade,
        getGradeColor: getGradeColor,
      ),
    );
  }
}