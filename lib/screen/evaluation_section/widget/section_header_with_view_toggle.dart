import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/exam_record/exam_record_bloc.dart';
import '../../../bloc/exam_record/exam_record_state.dart';
import 'student_count_badge.dart';

class SectionHeaderWithViewToggle extends StatelessWidget {
  final String title;
  final bool isGrid;
  final VoidCallback onToggleView;

  const SectionHeaderWithViewToggle({
    super.key,
    required this.title,
    required this.isGrid,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.people, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        BlocBuilder<ExamRecordBloc, ExamRecordState>(
          builder: (context, state) {
            final count = state.scores.length;
            return StudentCountBadge(count: count);
          },
        ),
        IconButton(
          icon: Icon(isGrid ? Icons.grid_view : Icons.list),
          tooltip: isGrid ? 'Grid view' : 'List view',
          onPressed: onToggleView,
        ),
      ],
    );
  }
}