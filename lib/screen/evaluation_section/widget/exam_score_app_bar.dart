import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/exam_record/exam_record_bloc.dart';
import '../../../bloc/exam_record/exam_record_state.dart';

class ExamScoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String subjectName;
  final int examMonth;
  final int examYear;
  final bool isPatching;
  final bool isUpdateMode;
  final VoidCallback onToggleUpdateMode;

  const ExamScoreAppBar({
    super.key,
    required this.subjectName,
    required this.examMonth,
    required this.examYear,
    required this.isPatching,
    required this.isUpdateMode,
    required this.onToggleUpdateMode,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(
        '$subjectName - $examMonth/$examYear',
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
            if (examState.scores.isNotEmpty && isPatching) {
              return IconButton(
                icon: Icon(
                  isUpdateMode ? Icons.cancel : Icons.edit,
                  color: colorScheme.primary,
                ),
                onPressed: onToggleUpdateMode,
                tooltip: isUpdateMode ? 'Cancel Edit' : 'Edit Scores',
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}