import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_bloc.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_event.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_state.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_bloc.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_event.dart';
import 'package:pat_asl_portal/bloc/exam_record/exam_record_state.dart';
import 'package:pat_asl_portal/data/model/dto/score_dto.dart';
import 'package:pat_asl_portal/data/model/score_with_student.dart';

import '../navigator/navigator_controller.dart';

class CreateOrPatchingExamScoreScreen extends StatefulWidget {
  final String classId;
  final String subjectId;
  final String subjectName;
  final String subjectLevelId;
  final String subjectLevelName;
  final int examMonth;
  final int examYear;
  final bool isPatching;

  const CreateOrPatchingExamScoreScreen({
    super.key,
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.subjectLevelId,
    required this.subjectLevelName,
    required this.examMonth,
    required this.examYear,
    required this.isPatching,
  });

  @override
  State<CreateOrPatchingExamScoreScreen> createState() =>
      _CreateOrPatchingExamScoreScreenState();
}

class _CreateOrPatchingExamScoreScreenState
    extends State<CreateOrPatchingExamScoreScreen> {
  final navigatorController = Get.find<NavigatorController>();
  bool isUpdateMode = false;
  bool hasSubmitted = false;
  final Map<String, String> _scoreInputs = {};
  final Map<String, TextEditingController> _controllers = {};
  final _formKey = GlobalKey<FormState>();

  void _toggleUpdateMode() {
    setState(() => isUpdateMode = !isUpdateMode);
  }

  String? _validateScore(String? value) {
    final score = double.tryParse(value ?? '');
    if (value == null || value.isEmpty) return 'Required';
    if (score == null) return 'Enter a valid number';
    if (score < 0 || score > 100) return 'Score must be 0-100';
    return null;
  }

  void _submitScores(List<dynamic> students) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final studentScores =
        students
            .map((enrollment) {
              final studentId = enrollment.student.studentId;
              final score = double.tryParse(_scoreInputs[studentId] ?? '') ?? 0;
              return StudentScoreInput(studentId: studentId, score: score);
            })
            .where((input) => _scoreInputs.containsKey(input.studentId))
            .toList();

    final dto = SetExamScoresDto(
      subjectId: widget.subjectId,
      examMonth: widget.examMonth,
      examYear: widget.examYear,
      studentScores: studentScores,
    );

    context.read<ExamRecordBloc>().add(SetExamScores(widget.classId, dto));
    setState(() => hasSubmitted = true);
  }

  void _patchScore(String scoreId, double score) {
    final dto = UpdateScoreDto(score: score);
    context.read<ExamRecordBloc>().add(
      UpdateExamScore(widget.classId, scoreId, dto),
    );
  }

  @override
  void initState() {
    super.initState();
    isUpdateMode = widget.isPatching;
    context.read<EnrollmentBloc>().add(
      FetchEnrollmentsByClassId(widget.classId),
    );
    context.read<ExamRecordBloc>().add(
      FetchExamScores(
        widget.classId,
        filter: GetExamScoresFilterDto(
          subjectId: widget.subjectId,
          examMonth: widget.examMonth,
          examYear: widget.examYear,
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocListener<ExamRecordBloc, ExamRecordState>(
        listener: (context, state) {
      if (state.status == ExamRecordStatus.patched) {
        // Refresh scores
        context.read<ExamRecordBloc>().add(
          FetchExamScores(
            widget.classId,
            filter: GetExamScoresFilterDto(
              subjectId: widget.subjectId,
              examMonth: widget.examMonth,
              examYear: widget.examYear,
            ),
          ),
        );
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('បន្ទុរពិនិត្យបានកែប្រែដោយជោគជ័យ!')),
        );
      } else if (state.status == ExamRecordStatus.set) {
        // Refresh scores
        context.read<ExamRecordBloc>().add(
          FetchExamScores(
            widget.classId,
            filter: GetExamScoresFilterDto(
              subjectId: widget.subjectId,
              examMonth: widget.examMonth,
              examYear: widget.examYear,
            ),
          ),
        );
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('វាយពិនិត្យបានបង្កើតដោយជោគជ័យ!')),
        );
      }else if (state.status == ExamRecordStatus.error) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage ?? 'បរាជ័យក្នុងការធ្វេីប្រតិបត្តិការ')),
        );
      }

    },
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.subjectName} - ${widget.examMonth}/${widget.examYear}',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 1,
        actions: [
          BlocBuilder<ExamRecordBloc, ExamRecordState>(
            builder: (context, examState) {
              if (examState.scores.isNotEmpty && widget.isPatching) {
                return IconButton(
                  icon: Icon(
                    isUpdateMode ? Icons.cancel : Icons.edit,
                    color: colorScheme.primary,
                  ),
                  onPressed: _toggleUpdateMode,
                  tooltip: isUpdateMode ? 'Cancel Edit' : 'Edit Scores',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<EnrollmentBloc, EnrollmentState>(
        builder: (context, enrollmentState) {
          if (enrollmentState.status == EnrollmentStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          final students = enrollmentState.enrollments;
          if (students == null || students.isEmpty) {
            return Center(
              child: Text(
                "No students found",
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          return BlocBuilder<ExamRecordBloc, ExamRecordState>(
            builder: (context, examState) {
              if (examState.status == ExamRecordStatus.loading) {
                return Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                );
              }

              final scores = examState.scores;
              final scoresExist = scores.isNotEmpty;

              if (!scoresExist) {
                // Create new scores
                return Form(
                  key: _formKey,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index].student;
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(
                              Icons.person,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          title: Text(
                            student.getFullName,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(student.studentNumber),
                          trailing: SizedBox(
                            width: 100,
                            child: TextFormField(
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Score',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: colorScheme.surfaceContainerHighest,
                              ),
                              onChanged: (value) {
                                _scoreInputs[student.id] = value;
                                setState(() {});
                              },
                              validator: _validateScore,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                // Patch existing scores
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: scores.length,
                  itemBuilder: (context, index) {
                    final scoreWithStudent = scores[index];
                    final student = scoreWithStudent.student;
                    final score = scoreWithStudent.score;
                    final scoreId = score.scoreId;

                    if (!_controllers.containsKey(scoreId)) {
                      _controllers[scoreId] = TextEditingController(
                        text: score.score.toString(),
                      );
                    }
                    final controller = _controllers[scoreId]!;

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
                          child: Icon(
                            Icons.person,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(
                          student.getFullName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text('Score: ${score.score}'),
                        trailing:
                            isUpdateMode
                                ? SizedBox(
                                  width: 140,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: controller,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          decoration: InputDecoration(
                                            labelText: 'Edit',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            filled: true,
                                            fillColor:
                                                colorScheme
                                                    .surfaceContainerHighest,
                                          ),
                                          onFieldSubmitted: (value) {
                                            final newScore =
                                                double.tryParse(value) ?? 0;
                                            _patchScore(scoreId, newScore);
                                          },
                                          validator: _validateScore,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      FilledButton.tonalIcon(
                                        style: FilledButton.styleFrom(
                                          minimumSize: const Size(40, 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          backgroundColor:
                                              colorScheme.errorContainer,
                                        ),
                                        icon: const Icon(Icons.clear, size: 20),
                                        onPressed: () {
                                          controller.clear();
                                          _patchScore(scoreId, 0);
                                        },
                                        label: const SizedBox.shrink(),
                                      ),
                                    ],
                                  ),
                                )
                                : null,
                      ),
                    );
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: BlocBuilder<ExamRecordBloc, ExamRecordState>(
        builder: (context, examState) {
          final scoresExist = examState.scores.isNotEmpty;
          final students =
              context.read<EnrollmentBloc>().state.enrollments ?? [];
          final allFilled =
              students.isNotEmpty &&
              students.every(
                (e) => _scoreInputs[e.student.id]?.isNotEmpty ?? false,
              );

          final canSubmit = !scoresExist && allFilled;
          if (canSubmit) {
            return FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Scores'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _submitScores(students);
                }
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    )
    );
  }
}
