import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/score_card.dart';

class ScoresGridView extends StatelessWidget {
  final List<dynamic> scores;
  final String Function(num) getGrade;
  final Color Function(String, ColorScheme) getGradeColor;

  const ScoresGridView({
    super.key,
    required this.scores,
    required this.getGrade,
    required this.getGradeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
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