import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/exam_record/exam_record_bloc.dart';
import '../../../bloc/exam_record/exam_record_state.dart';
import '../../../util/helper_screen/state_screen.dart';
import '../../navigator/navigator_controller.dart';
import '../create_or_patching_exam_score_screen.dart';
import 'empty_scores_view.dart';
import 'loaded_scores_view.dart';
import 'loading_scores_view.dart';

class ScoresContentSection extends StatelessWidget {
  final int examMonth;
  final int examYear;
  final List<String> months;
  final bool isGrid;
  final NavigatorController navigatorController;
  final String classId;
  final String subjectId;
  final String subjectName;
  final String subjectLevelId;
  final String subjectLevelName;

  const ScoresContentSection({
    super.key,
    required this.examMonth,
    required this.examYear,
    required this.months,
    required this.isGrid,
    required this.navigatorController,
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectLevelId,
    required this.subjectLevelName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamRecordBloc, ExamRecordState>(
      builder: (context, state) {
        if (state.status == ExamRecordStatus.loading) {
          return const LoadingScoresView();
        } else if (state.status == ExamRecordStatus.error) {
          return ErrorState(
            errorMessage:
            'វាហាក់ដូចជាមិនមានពិន្ទុដែលបានបញ្ចូលសម្រាប់ ${months[examMonth - 1]} $examYear.',
          );
        } else if (state.status == ExamRecordStatus.loaded) {
          final scores = state.scores;
          if (scores.isEmpty) {
            return EmptyScoresView(
              month: months[examMonth - 1],
              year: examYear,
              onCreateScores: () {
                navigatorController.pushToCurrentTab(
                  CreateOrPatchingExamScoreScreen(
                    classId: classId,
                    subjectId: subjectId,
                    subjectName: subjectName,
                    subjectLevelId: subjectLevelId,
                    subjectLevelName: subjectLevelName,
                    examMonth: examMonth,
                    examYear: examYear,
                    isPatching: false,
                  ),
                );
              },
            );
          }

          return LoadedScoresView(scores: scores, isGrid: isGrid);
        }
        return const SizedBox.shrink();
      },
    );
  }
}