import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/exam_record/exam_record_bloc.dart';
import '../../../bloc/exam_record/exam_record_state.dart';
import '../../evaluation_section/widget/action_button.dart';
import '../../navigator/navigator_controller.dart';
import '../../report/student_report_screen.dart';
import '../create_or_patching_exam_score_screen.dart';

class ExamActionButtons extends StatelessWidget {
  final int examMonth;
  final int examYear;
  final String classId;
  final String subjectId;
  final String subjectName;
  final String subjectLevelId;
  final String subjectLevelName;
  final NavigatorController navigatorController;

  const ExamActionButtons({
    super.key,
    required this.examMonth,
    required this.examYear,
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectLevelId,
    required this.subjectLevelName,
    required this.navigatorController,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ExamRecordBloc, ExamRecordState>(
      builder: (context, state) {
        if (state.status == ExamRecordStatus.loaded &&
            state.scores.isNotEmpty) {
          return Positioned(
            bottom: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ActionButton(
                  icon: Icons.insert_drive_file,
                  label: 'របាយការណ៍',
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    navigatorController.pushToCurrentTab(
                      StudentReportScreen(
                        classId: classId,
                        reportMonth: examMonth,
                        reportYear: examYear,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                ActionButton(
                  icon: Icons.edit,
                  label: 'កែប្រែបន្ទុះ',
                  backgroundColor: colorScheme.primary,
                  onPressed: () {
                    navigatorController.pushToCurrentTab(
                      CreateOrPatchingExamScoreScreen(
                        classId: classId,
                        subjectId: subjectId,
                        subjectName: subjectName,
                        subjectLevelId: subjectLevelId,
                        subjectLevelName: subjectLevelName,
                        examMonth: examMonth,
                        examYear: examYear,
                        isPatching: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}