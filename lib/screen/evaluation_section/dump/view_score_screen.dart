import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_bloc.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_event.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_state.dart';
import 'package:pat_asl_portal/data/model/score_with_student.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import '../../../../data/model/dto/score_dto.dart';
import '../evaluation_screen.dart';

class ViewScoreScreen extends StatefulWidget {
  final String classId;
  final int examMonth;
  final int examYear;

  const ViewScoreScreen({
    super.key,
    required this.classId,
    required this.examMonth,
    required this.examYear,
  });

  @override
  State<ViewScoreScreen> createState() => _ViewScoreScreenState();
}

class _ViewScoreScreenState extends State<ViewScoreScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch scores when screen loads
    context.read<ExamRecordBloc>().add(
      FetchExamScores(
        widget.classId,
        filter: GetExamScoresFilterDto(
          examMonth: widget.examMonth,
          examYear: widget.examYear,
        ),
      ),
    );
  }

  String getKhmerMonthName(int month) {
    if (month < 1 || month > 12) throw ArgumentError("Invalid month number: $month");
    return KhmerMonth.values[month - 1].khmer;
  }


  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.orange;
      case 'C':
        return Colors.amber;
      case 'D':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          debugPrint('Refreshing records...');
        },

        child: BlocBuilder<ExamRecordBloc, ExamRecordState>(
          builder: (context, state) {
            if (state.status == ExamRecordStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == ExamRecordStatus.error) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state.status == ExamRecordStatus.loaded) {
              final scores = state.scores;

              if (scores.isEmpty) {
                return Center(
                  child: Text(
                    'គ្មានពិន្ទុសម្រាប់ថ្នាក់នេះសម្រាប់ខែ ${getKhmerMonthName(widget.examMonth)} ឆ្នាំ ${widget.examYear}',
                    style: TextStyle(fontSize: 16),
                  )
                  ,
                );
              }

              return ListView.separated(
                itemCount: scores.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final ScoreWithStudent scoreWithStudent = scores[index];
                  final score = scoreWithStudent.score;
                  final student = scoreWithStudent.student;

                  final colorScheme = Theme.of(context).colorScheme;
                  final textTheme = Theme.of(context).textTheme;

                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Text(
                              student.studentNumber,
                              style: textTheme.labelLarge?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.getFullName,
                                  style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w900, color: Colors.black
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'បន្ទុក: ${score.score} / ${score.maxScore} (${score.percentage.toStringAsFixed(1)}%)',
                                  style: textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Chip(
                            avatar: Icon(
                              Icons.grade,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(
                              score.grade,
                              style: textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: _getGradeColor(score.grade),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
