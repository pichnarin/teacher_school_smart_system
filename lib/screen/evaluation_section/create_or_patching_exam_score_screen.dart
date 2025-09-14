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
import 'package:pat_asl_portal/screen/evaluation_section/widget/create_scores_form.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/empty_students_view.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/exam_score_app_bar.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/save_scores_button.dart';
import 'package:pat_asl_portal/screen/evaluation_section/widget/update_scores_list.dart';

import '../daily_evaluation/widget/loading_indicator.dart';
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
              final studentId = enrollment.student.id;
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
    _fetchScores();
  }

  void _fetchScores() {
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
    return BlocListener<ExamRecordBloc, ExamRecordState>(
      listener: (context, state) {
        if (state.status == ExamRecordStatus.patched ||
            state.status == ExamRecordStatus.set) {
          _fetchScores();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.status == ExamRecordStatus.patched
                    ? 'បន្ទុរពិនិត្យបានកែប្រែដោយជោគជ័យ!'
                    : 'វាយពិនិត្យបានបង្កើតដោយជោគជ័យ!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == ExamRecordStatus.error) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'បរាជ័យក្នុងការធ្វេីប្រតិបត្តិការ',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: ExamScoreAppBar(
          subjectName: widget.subjectName,
          examMonth: widget.examMonth,
          examYear: widget.examYear,
          isPatching: widget.isPatching,
          isUpdateMode: isUpdateMode,
          onToggleUpdateMode: _toggleUpdateMode,
        ),
        body: BlocBuilder<EnrollmentBloc, EnrollmentState>(
          builder: (context, enrollmentState) {
            if (enrollmentState.status == EnrollmentStatus.loading) {
              return const LoadingIndicator();
            }

            final students = enrollmentState.enrollments;
            if (students == null || students.isEmpty) {
              return const EmptyStudentsView();
            }

            return BlocBuilder<ExamRecordBloc, ExamRecordState>(
              builder: (context, examState) {
                if (examState.status == ExamRecordStatus.loading) {
                  return const LoadingIndicator();
                }

                final scores = examState.scores;
                final scoresExist = scores.isNotEmpty;

                if (!scoresExist) {
                  return CreateScoresForm(
                    formKey: _formKey,
                    students: students,
                    onScoreChanged: (studentId, value) {
                      _scoreInputs[studentId] = value;
                      setState(() {});
                    },
                    validateScore: _validateScore,
                  );
                } else {
                  return UpdateScoresList(
                    scores: scores,
                    isUpdateMode: isUpdateMode,
                    controllers: _controllers,
                    onPatchScore: _patchScore,
                    validateScore: _validateScore,
                  );
                }
              },
            );
          },
        ),
        floatingActionButton: SaveScoresButton(
          onSubmit:
              () => _submitScores(
                context.read<EnrollmentBloc>().state.enrollments ?? [],
              ),
          formKey: _formKey,
          scoreInputs: _scoreInputs,
        ),
      ),
    );
  }
}












