import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/daily_evaluation/daily_evaluation_bloc.dart';
import 'package:pat_asl_portal/bloc/daily_evaluation/daily_evaluation_event.dart';
import 'package:pat_asl_portal/bloc/daily_evaluation/daily_evaluation_state.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_bloc.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_event.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_state.dart';
import 'package:pat_asl_portal/data/model/dto/daily_evaluation_dto.dart';

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
  final List<String> evaluationOptions = [
    'perfect',
    'good',
    'average',
    'poor',
    'none',
  ];
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
          listener: (context, state) {
            if (state.status == DailyEvaluationStatus.created ||
                state.status == DailyEvaluationStatus.patched) {
              context.read<DailyEvaluationBloc>().add(
                FetchDailyEvaluations(widget.classId, widget.sessionDate),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.status == DailyEvaluationStatus.created
                        ? "បានបង្កើតការវាយតម្លៃដោយជោគជ័យ"
                        : "បានរក្សាទុកដោយជោគជ័យ",
                  ),
                ),
              );
            } else if (state.status == DailyEvaluationStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'បរាជ័យក្នុងការធ្វេីប្រតិបត្តិការ',
                  ),
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isPatching ? "កែតម្លៃការវាយតម្លៃ" : "បង្កើតការវាយតម្លៃ",
          ),
        ),
        body:
            widget.isPatching
                ? _buildPatchUI()
                : BlocBuilder<EnrollmentBloc, EnrollmentState>(
                  builder: (context, enrollState) {
                    final students = enrollState.enrollments ?? [];

                    if (students.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    for (var s in students) {
                      studentInputs.putIfAbsent(
                        s.student.id,
                        () => {
                          "homework": evaluationOptions.first,
                          "clothing": evaluationOptions.first,
                          "attitude": evaluationOptions.first,
                          "class_activity": 0,
                        },
                      );
                    }

                    return _buildForm(students);
                  },
                ),
      ),
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
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                dynamic entry = students[index];
                final student =
                    entry is EnrollmentWithStudent ? entry.student : entry;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.grey.shade300,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${student.studentNumber} - ${student.firstName} ${student.lastName}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _dropdown("Homework", student.id, "homework"),
                            const SizedBox(width: 10),
                            _dropdown("Clothes", student.id, "clothing"),
                            const SizedBox(width: 10),
                            _dropdown("Attitude", student.id, "attitude"),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Class Activity: ${studentInputs[student.id]!['class_activity']}",
                        ),
                        Slider(
                          value:
                              studentInputs[student.id]!['class_activity']
                                  .toDouble(),
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label:
                              studentInputs[student.id]!['class_activity']
                                  .toString(),
                          onChanged: (value) {
                            setState(() {
                              studentInputs[student.id]!['class_activity'] =
                                  value.toInt();
                              changedStudentIds.add(student.id);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("រក្សាទុក"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              if (widget.isPatching) {
                final patchPayload =
                    studentInputs.entries
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
                    const SnackBar(content: Text("No changes to save.")),
                  );
                  return;
                }

                context.read<DailyEvaluationBloc>().add(
                  PatchDailyEvaluations(patchPayload),
                );
              } else {
                final createPayload =
                    studentInputs.entries.map((entry) {
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
            },
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String label, String studentId, String field) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: studentInputs[studentId]?[field],
        onChanged: (value) {
          setState(() {
            studentInputs[studentId]?[field] = value!;
            changedStudentIds.add(studentId);
          });
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items:
            evaluationOptions
                .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
                .toList(),
      ),
    );
  }
}
