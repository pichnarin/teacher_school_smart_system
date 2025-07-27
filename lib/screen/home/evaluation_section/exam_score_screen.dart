import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_event.dart';
import 'package:pat_asl_portal/data/model/dto/score_dto.dart';
import 'package:pat_asl_portal/screen/global_widget/base_screen.dart';
import 'package:pat_asl_portal/screen/home/evaluation_section/create_or_patching_exam_score_screen.dart';
import 'package:pat_asl_portal/util/helper_screen/state_screen.dart';
import '../../../bloc/exam_record/exam_record_bloc.dart';
import '../../../bloc/exam_record/exam_record_state.dart';
import '../../navigator/navigator_controller.dart';

class ExamScoreScreen extends StatefulWidget {
  final String classId;
  final String subjectId;
  final String subjectName;
  final String subjectLevelId;
  final String subjectLevelName;
  const ExamScoreScreen({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectLevelId,
    required this.subjectLevelName,
  });

  @override
  State<ExamScoreScreen> createState() => _ExamScoreScreenState();
}

class _ExamScoreScreenState extends State<ExamScoreScreen> {
  final navigatorController = Get.find<NavigatorController>();
  late int examMonth;
  late int examYear;
  bool isGrid = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    examMonth = now.month;
    examYear = now.year;
    _fetchScores();
  }

  void _fetchScores() {
    context.read<ExamRecordBloc>().add(
      FetchExamScores(
        widget.classId,
        filter: GetExamScoresFilterDto(
          examMonth: examMonth,
          examYear: examYear,
          subjectId: widget.subjectId,
        ),
      ),
    );
  }

  String getGrade(num score) {
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    if (score >= 50) return 'E';
    return 'F';
  }

  Color getGradeColor(String grade, ColorScheme colorScheme) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.amber;
      case 'D':
        return Colors.orange;
      case 'E':
        return Colors.deepOrange;
      default:
        return colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear - i);
    final colorScheme = Theme.of(context).colorScheme;

    return BaseScreen(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => _fetchScores(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.primaryContainer],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.score, color: colorScheme.onPrimary, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Exam Scores for ${widget.subjectName} (${widget.subjectLevelName})',
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'View student scores by month and year',
                        style: TextStyle(
                          color: colorScheme.onPrimary.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Month & Year Picker
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 12,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final monthNum = index + 1;
                            final isSelected = monthNum == examMonth;
                            return FilledButton.tonal(
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                isSelected
                                    ? colorScheme.primary
                                    : colorScheme.surfaceContainerHighest,
                                foregroundColor:
                                isSelected
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurfaceVariant,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  examMonth = monthNum;
                                  _fetchScores();
                                });
                              },
                              child: Text(
                                months[index],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<int>(
                      value: examYear,
                      style: Theme.of(context).textTheme.titleMedium,
                      dropdownColor: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      items:
                      years
                          .map(
                            (y) => DropdownMenuItem(
                          value: y,
                          child: Text(y.toString()),
                        ),
                      )
                          .toList(),
                      onChanged: (y) {
                        if (y != null) {
                          setState(() {
                            examYear = y;
                            _fetchScores();
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Section Header & Stats
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.people,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Scores for ${months[examMonth - 1]} $examYear",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    BlocBuilder<ExamRecordBloc, ExamRecordState>(
                      builder: (context, state) {
                        final count = state.scores.length;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$count students',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        );
                      },
                    ),
                    // Toggle button
                    IconButton(
                      icon: Icon(isGrid ? Icons.grid_view : Icons.list),
                      tooltip: isGrid ? 'Grid view' : 'List view',
                      onPressed: () {
                        setState(() {
                          isGrid = !isGrid;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Scores List/Grid
                BlocBuilder<ExamRecordBloc, ExamRecordState>(
                  builder: (context, state) {
                    if (state.status == ExamRecordStatus.loading) {
                      return Container(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            CircularProgressIndicator(color: colorScheme.primary),
                            const SizedBox(height: 16),
                            Text(
                              'Loading scores...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state.status == ExamRecordStatus.error) {
                      return ErrorState(errorMessage: 'It seems there are no scores entered for ${months[examMonth - 1]} $examYear.');
                    } else if (state.status == ExamRecordStatus.loaded) {
                      final scores = state.scores;
                      if (scores.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.hourglass_empty,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No exam scores recorded yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'It seems there are no scores entered for ${months[examMonth - 1]} $examYear.\nPlease check back later or create exam score for current month.',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: (){
                                  navigatorController.pushToCurrentTab(
                                    CreateOrPatchingExamScoreScreen(
                                      classId: widget.classId,
                                      subjectId: widget.subjectId,
                                      subjectName: widget.subjectName,
                                      subjectLevelId: widget.subjectLevelId,
                                      subjectLevelName: widget.subjectLevelName,
                                      examMonth: examMonth,
                                      examYear: examYear,
                                      isPatching: false,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.create),
                                label: const Text('Create'),
                              ),
                            ],
                          ),
                        );
                      }
                      // Stats summary
                      final avgScore =
                          scores.fold<double>(0, (a, b) => a + b.score.getScore) /
                              scores.length;
                      itemBuilder(BuildContext context, int index) {
                        final score = scores[index];
                        final grade = getGrade(score.score.maxScore);
                        final gradeColor = getGradeColor(grade, colorScheme);
                        return Card(
                          elevation: 0,
                          color: colorScheme.surfaceContainerHighest,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: gradeColor,
                                  child: Text(
                                    grade,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        score.student.getFullName,
                                        style: Theme.of(context).textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        'Score: ${score.score.getScore.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      }
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatItem(
                                  icon: Icons.people,
                                  label: 'Total Students',
                                  value: scores.length.toString(),
                                  color: colorScheme.primary,
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: colorScheme.primary.withOpacity(0.2),
                                ),
                                _buildStatItem(
                                  icon: Icons.star,
                                  label: 'Avg. Score',
                                  value: avgScore.toStringAsFixed(1),
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                          isGrid
                              ? GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: scores.length,
                            itemBuilder: itemBuilder,
                          )
                              : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: scores.length,
                            itemBuilder: itemBuilder,
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          BlocBuilder<ExamRecordBloc, ExamRecordState>(
            builder: (context, state) {
              if (state.status == ExamRecordStatus.loaded && state.scores.isNotEmpty) {
                return Positioned(
                  bottom: 24,
                  right: 24,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text('Patch Scores'),
                    onPressed: () {
                      navigatorController.pushToCurrentTab(
                        CreateOrPatchingExamScoreScreen(
                          classId: widget.classId,
                          subjectId: widget.subjectId,
                          subjectName: widget.subjectName,
                          subjectLevelId: widget.subjectLevelId,
                          subjectLevelName: widget.subjectLevelName,
                          examMonth: examMonth,
                          examYear: examYear,
                          isPatching: true,
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ]
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
