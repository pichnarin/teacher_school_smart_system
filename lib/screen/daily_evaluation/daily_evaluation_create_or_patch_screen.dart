import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/daily_evaluation/daily_evaluation_bloc.dart';
import 'package:pat_asl_portal/bloc/daily_evaluation/daily_evaluation_event.dart';
import 'package:pat_asl_portal/bloc/daily_evaluation/daily_evaluation_state.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_bloc.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_event.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_state.dart';
import 'package:pat_asl_portal/data/model/dto/daily_evaluation_dto.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/save_button.dart';
import 'package:pat_asl_portal/screen/daily_evaluation/widget/student_list.dart';

import '../../../data/model/enrollment_with_student.dart';

class DailyEvaluationCreateOrPatchScreen extends StatefulWidget {
  final String classId;
  final String classSessionId;
  final String sessionDate;
  final String subjectName;
  final String subjectLevelName;
  final String roomName;
  final String subjectId;
  final String subjectLevelId;
  final String startTime;
  final String endTime;
  final bool isPatching;

  const DailyEvaluationCreateOrPatchScreen({
    super.key,
    required this.classId,
    required this.classSessionId,
    required this.sessionDate,
    required this.subjectName,
    required this.subjectLevelName,
    required this.roomName,
    required this.subjectId,
    required this.subjectLevelId,
    required this.startTime,
    required this.endTime,
    required this.isPatching,
  });


  @override
  State<DailyEvaluationCreateOrPatchScreen> createState() =>
      _DailyEvaluationCreateOrPatchScreenState();
}

class _DailyEvaluationCreateOrPatchScreenState
    extends State<DailyEvaluationCreateOrPatchScreen> {
  final List<String> evaluationOptionKeys = [
    'perfect', 'good', 'average', 'poor', 'none',
  ];

  final Map<String, String> evaluationOptions = {
    'perfect': 'ល្អបំផុត', 'good': 'ល្អ', 'average': 'មធ្យម',
    'poor': 'មិនល្អ', 'none': 'រង់ចាំ',
  };

  final Map<String, Map<String, dynamic>> studentInputs = {};
  final Set<String> changedStudentIds = {};

  @override
  void initState() {
    super.initState();
    if (widget.isPatching) {
      context.read<DailyEvaluationBloc>().add(
        FetchDailyEvaluations(widget.classId, widget.sessionDate),
      );
    } else {
      context.read<EnrollmentBloc>().add(
        FetchEnrollmentsByClassId(widget.classId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DailyEvaluationBloc, DailyEvaluationState>(
          listener: _handleBlocStateChanges,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isPatching ? "កែតម្លៃការវាយតម្លៃ" : "បង្កើតការវាយតម្លៃ",
          ),
        ),
        body: widget.isPatching
            ? _buildPatchUI()
            : _buildCreateUI(),
      ),
    );
  }

  void _handleBlocStateChanges(BuildContext context, DailyEvaluationState state) async {
    if (state.status == DailyEvaluationStatus.created ||
        state.status == DailyEvaluationStatus.patched) {
      context.read<DailyEvaluationBloc>().add(
        FetchDailyEvaluations(widget.classId, widget.sessionDate),
      );
      _showSuccessSnackBar(state.status == DailyEvaluationStatus.created);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else if (state.status == DailyEvaluationStatus.error) {
      _showErrorSnackBar(state.errorMessage);
    }
  }

  void _showSuccessSnackBar(bool isCreated) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCreated ? "បានបង្កើតការវាយតម្លៃដោយជោគជ័យ" : "បានរក្សាទុកដោយជោគជ័យ",
        ),
        backgroundColor: isCreated ? Colors.green : Colors.blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'បរាជ័យក្នុងការធ្វេីប្រតិបត្តិការ'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildCreateUI() {
    return BlocBuilder<EnrollmentBloc, EnrollmentState>(
      builder: (context, enrollState) {
        final students = enrollState.enrollments ?? [];

        if (students.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        for (var s in students) {
          studentInputs.putIfAbsent(
            s.student.id,
            () => {
              "homework": evaluationOptionKeys.first,
              "clothing": evaluationOptionKeys.first,
              "attitude": evaluationOptionKeys.first,
              "class_activity": 0,
            },
          );
        }

        return _buildForm(students);
      },
    );
  }

  Widget _buildPatchUI() {
    return BlocBuilder<DailyEvaluationBloc, DailyEvaluationState>(
      builder: (context, state) {
        final evaluations = state.dailyEvaluations ?? [];

        if (evaluations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        for (var e in evaluations) {
          studentInputs.putIfAbsent(
            e.student.id,
            () => {
              "homework": e.homework,
              "clothing": e.clothing,
              "attitude": e.attitude,
              "class_activity": e.classActivity,
              "id": e.id,
            },
          );
        }

        return _buildForm(evaluations.map((e) => e.student).toList());
      },
    );
  }

  Widget _buildForm(List<dynamic> students) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: StudentList(
              students: students,
              studentInputs: studentInputs,
              evaluationOptionKeys: evaluationOptionKeys,
              evaluationOptions: evaluationOptions,
              onInputChanged: _updateStudentInput,
              onSliderChanged: _updateActivityScore,
            ),
          ),
          SaveButton(
            onPressed: _handleSave,
          ),
        ],
      ),
    );
  }

  void _updateStudentInput(String studentId, String field, String value) {
    setState(() {
      studentInputs[studentId]?[field] = value;
      changedStudentIds.add(studentId);
    });
  }

  void _updateActivityScore(String studentId, double value) {
    setState(() {
      studentInputs[studentId]!['class_activity'] = value.toInt();
      changedStudentIds.add(studentId);
    });
  }

  void _handleSave() {
    if (widget.isPatching) {
      _handlePatchSave();
    } else {
      _handleCreateSave();
    }
  }

  void _handlePatchSave() {
    final patchPayload = studentInputs.entries
        .where((entry) => changedStudentIds.contains(entry.key))
        .map((entry) {
          final data = entry.value;
          return DailyEvaluationPatch(
            id: data['id'],
            homework: data['homework'],
            clothing: data['clothing'],
            attitude: data['attitude'],
            classActivity: data['class_activity'],
          ).toJson();
        })
        .toList();

    if (patchPayload.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No changes to save."),
          backgroundColor: Colors.red
        ),
      );
      return;
    }

    context.read<DailyEvaluationBloc>().add(
      PatchDailyEvaluations(patchPayload),
    );
  }

  void _handleCreateSave() {
    final createPayload = studentInputs.entries.map((entry) {
      final data = entry.value;
      return DailyEvaluationCreateDTO(
        studentId: entry.key,
        homework: data['homework'],
        clothing: data['clothing'],
        attitude: data['attitude'],
        classActivity: data['class_activity'],
      );
    }).toList();

    context.read<DailyEvaluationBloc>().add(
      CreateDailyEvaluations(widget.classSessionId, createPayload),
    );
  }
}








