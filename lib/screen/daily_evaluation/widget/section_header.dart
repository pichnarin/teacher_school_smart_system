import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/session_info.dart';

class SessionHeader extends StatelessWidget {
  final SessionInfo sessionInfo;

  const SessionHeader({super.key, required this.sessionInfo});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Daily Evaluations for (${sessionInfo.date} - ${sessionInfo.roomName} - ${sessionInfo.subjectName} - '
          '${sessionInfo.subjectLevelName} - ${sessionInfo.startTime} - ${sessionInfo.endTime})',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}