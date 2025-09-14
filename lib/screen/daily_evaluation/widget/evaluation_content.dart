import 'package:flutter/cupertino.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/section_header.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/session_info.dart';

import '../daily_evaluation_screen.dart';
import 'evaluation_list.dart';

class EvaluationsContent extends StatelessWidget {
  final List<dynamic> evaluations;
  final SessionInfo sessionInfo;

  const EvaluationsContent({
    super.key,
    required this.evaluations,
    required this.sessionInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SessionHeader(sessionInfo: sessionInfo),
        const SizedBox(height: 16),
        EvaluationsList(evaluations: evaluations),
      ],
    );
  }
}

