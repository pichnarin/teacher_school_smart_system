import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/enrollment/enrollment_bloc.dart';
import '../../../bloc/exam_record/exam_record_bloc.dart';
import '../../../bloc/exam_record/exam_record_state.dart';

class SaveScoresButton extends StatelessWidget {
  final VoidCallback onSubmit;
  final GlobalKey<FormState> formKey;
  final Map<String, String> scoreInputs;

  const SaveScoresButton({
    super.key,
    required this.onSubmit,
    required this.formKey,
    required this.scoreInputs,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ExamRecordBloc, ExamRecordState>(
      builder: (context, examState) {
        final scoresExist = examState.scores.isNotEmpty;
        final students = context.read<EnrollmentBloc>().state.enrollments ?? [];
        final allFilled =
            students.isNotEmpty &&
                students.every(
                      (e) => scoreInputs[e.student.id]?.isNotEmpty ?? false,
                );

        final canSubmit = !scoresExist && allFilled;
        if (canSubmit) {
          return FilledButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save Scores'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                onSubmit();
              }
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}