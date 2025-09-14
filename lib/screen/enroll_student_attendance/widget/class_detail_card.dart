import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/class_session/class_session_bloc.dart';
import '../../../bloc/class_session/class_session_state.dart';
import '../../../data/model/class_session.dart';
import '../../../util/formatter/time_of_the_day_formater.dart';
import '../../../util/helper_screen/state_screen.dart';
import '../../home/widget/suggest_class_card.dart';

class ClassDetailsCard extends StatelessWidget {
  final String classSessionId;

  const ClassDetailsCard({
    super.key,
    required this.classSessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: BlocBuilder<ClassSessionBloc, ClassSessionState>(
        builder: (context, state) {
          switch (state.status) {
            case ClassStatus.loading:
              return const LoadingState();
            case ClassStatus.error:
              return ErrorState(errorMessage: state.errorMessage ?? 'Unknown error');
            case ClassStatus.loaded:
              final classItem = state.classFilterById;
              if (classItem != null) {
                return _buildClassDetails(classItem);
              }
              return const EmptyState();
            default:
              return const EmptyState();
          }
        },
      ),
    );
  }

  Widget _buildClassDetails(ClassSession classItem) {
    return SuggestedClassCard(
      sessionType: classItem.sessionType.sessionType,
      status: classItem.status,
      classGrade: classItem.classInfo.subjectLevel.name.toUpperCase(),
      classSubject: classItem.subject.subjectName.toUpperCase(),
      classDate: classItem.sessionDate,
      startTime: TimeFormatter.format(classItem.startTime),
      endTime: TimeFormatter.format(classItem.endTime),
      totalStudents: classItem.studentCount.toString(),
      roomName: classItem.room.roomName.toUpperCase(),
    );
  }
}